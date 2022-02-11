#!/usr/bin/env python3
import argparse
import re
import time
import sys
import os
import math
import threading
import subprocess
import traceback


RE_CPU_LINE = re.compile(r'^cpu(\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+)')

class CpuLoad(object):
    def __init__(self, cpu_id):
        self.cpu_id = cpu_id

        self.cnt_user = None
        self.cnt_nice = None
        self.cnt_sys  = None
        self.cnt_idle = None
        self.cnt_iowait = None
        self.cnt_irq = None
        self.cnt_softirq = None

        self.cnt_total = None
        self.cnt_used = None

    def fixup(self):
        self.cnt_used = self.cnt_user + self.cnt_nice + self.cnt_sys \
                        + self.cnt_irq + self.cnt_softirq
        self.cnt_total = self.cnt_used + self.cnt_idle + self.cnt_iowait


class CpuLoadSet(object):
    def __init__(self):
        self.max_cpu_id = -1
        self.cpu_load = {}

    def add(self, cpu_load):
        cpu_id = cpu_load.cpu_id
        self.cpu_load[cpu_id] = cpu_load
        if cpu_id > self.max_cpu_id:
            self.max_cpu_id = cpu_id

    def __len__(self):
        return self.max_cpu_id + 1

    def __getitem__(self, key):
        return self.cpu_load[key]


class Data(object):
    def __init__(self, cpu_load_set):
        self.cpu_load_set = cpu_load_set


def format_tempreture(temp: float) -> str:
    return f'{temp:.1f}'


class SystemTempreture(object):
    SYS_THERMAL = '/sys/class/thermal'

    def __init__(self):
        self.temp_file_path_list = self.__get_temperature_file_path_list()

    def __get_temperature_file_path_list(self):
        re_zone = re.compile(r'^thermal_zone(\d)')
        temp_file_path_list = []
        for filename in os.listdir(os.path.join(SystemTempreture.SYS_THERMAL)): 
            match = re_zone.match(filename)
            if not match:
                continue
            temp_file_path_list.append(f'{SystemTempreture.SYS_THERMAL}/{filename}/temp')
        return temp_file_path_list

    def __get_zone_temp_str(self, temp_file_path) -> str:
        with open(temp_file_path) as f:
           return format_tempreture(float(f.read())/1e3)

    def get_line(self):
        return ' '.join([self.__get_zone_temp_str(path) for path in self.temp_file_path_list])


class GpuInfo(threading.Thread):
    def __init__(self, args):
        threading.Thread.__init__(self)
        self.num_gpus = self.__get_num_gpus()
        self.args = args
        self.temp_list = [None] * self.num_gpus

    def __get_num_gpus(self):
        result = subprocess.run(['nvidia-smi', '--query-gpu=name', '--format=csv,noheader'],
                                stdout=subprocess.PIPE, check=True, encoding='UTF-8')
        names = list(filter(lambda s: len(s) > 0, result.stdout.split('\n')))
        return len(names)

    def __run(self):
        cmd = ['nvidia-smi', '--query-gpu=temperature.gpu', '--format=csv,noheader',
               '-l', f'{self.args.interval}']
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, encoding='UTF-8')

        while True:
            self.__update_tempreture(proc)

    def __update_tempreture(self, proc):
        for idx in range(self.num_gpus):
            self.temp_list[idx] = float(proc.stdout.readline())

    def run(self):
        try:
            self.__run()
        except:
            traceback.print_exc()
            os._exit(1)

    def get_line(self):
        return '🌡 ' + ' '.join([format_tempreture(t) for t in self.temp_list])


class MemoryInfo(object):
    def __init__(self):
        self.total = self.__read_meminfo('MemTotal')
        assert self.total

    def __read_meminfo(self, item):
        search_key = item + ':'
        with open('/proc/meminfo') as f:
            for line in f:
                words = line.split()
                if len(words) != 3:
                    continue
                if words[0] == search_key:
                    return int(words[1])
        return None

    def get_line(self):
        avail = self.__read_meminfo('MemAvailable')
        assert avail
        used = int((self.total - avail) / 1024) # MiB
        return f'{used:,}'


def get_each_cpu_load(line) -> CpuLoad:
    match = RE_CPU_LINE.match(line)
    if not match:
        return None

    cpu_id = int(match.group(1))
    cl = CpuLoad(cpu_id)

    cl.cnt_user    = int(match.group(2))
    cl.cnt_nice    = int(match.group(3))
    cl.cnt_sys     = int(match.group(4))
    cl.cnt_idle    = int(match.group(5))
    cl.cnt_iowait  = int(match.group(6))
    cl.cnt_irq     = int(match.group(7))
    cl.cnt_softirq = int(match.group(8))

    cl.fixup()
    return cl


def get_cpu_load() -> CpuLoadSet:
    cpu_load_set = CpuLoadSet()
    with open('/proc/stat') as f:
        for line in f:
            cpu_load = get_each_cpu_load(line)
            if cpu_load is None:
                continue
            cpu_load_set.add(cpu_load)
    return cpu_load_set


LOAD_BARS = ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']
NUM_LOAD_BARS = len(LOAD_BARS)

def get_load_bar_char(args, load):
    if load <= args.cpu_bar_min:
        return ' '
    if load >= args.cpu_bar_max:
        return LOAD_BARS[-1]

    bin_width = (args.cpu_bar_max - args.cpu_bar_min) / (NUM_LOAD_BARS - 1)
    a = 1.0 / bin_width
    b = -a * args.cpu_bar_min
    idx = math.floor(a * load + b)
    return LOAD_BARS[idx]


def show_each_cpu_load(args, prev_cpu_load, curr_cpu_load):
    diff_used = curr_cpu_load.cnt_used - prev_cpu_load.cnt_used
    diff_total = curr_cpu_load.cnt_total - prev_cpu_load.cnt_total
    load = diff_used / diff_total
    return get_load_bar_char(args, load)


def get_cpu_load_line(args, prev_cpu_load_set, curr_cpu_load_set) -> str:
    num_cpu = len(curr_cpu_load_set)
    assert len(prev_cpu_load_set) == num_cpu

    s = 'CPU '
    for idx in range(num_cpu):
        s += show_each_cpu_load(args, prev_cpu_load_set[idx], curr_cpu_load_set[idx])
    return s


def show(args, prev_data, curr_data, sys_tempreture, gpu_info, mem_info):
    if prev_data is None:
        return

    s = ''
    s += get_cpu_load_line(args, prev_data.cpu_load_set, curr_data.cpu_load_set)
    s += ' 🌡 '
    s += sys_tempreture.get_line()
    s += ' GPU '
    s += gpu_info.get_line()
    s += ' MEM '
    s += mem_info.get_line()

    print(s)


def run(args):
    prev_data = None
    sys_tempreture = SystemTempreture()

    gpu_info = GpuInfo(args)
    gpu_info.start()

    mem_info = MemoryInfo()

    while True:
        cpu_load_set = get_cpu_load()
        curr_data = Data(cpu_load_set)
        show(args, prev_data, curr_data, sys_tempreture, gpu_info, mem_info)
        prev_data = curr_data
        time.sleep(args.interval)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--interval', type=int, default=1)
    parser.add_argument('--cpu-bar-min', type=float, default=0.05)
    parser.add_argument('--cpu-bar-max', type=float, default=0.9)
    args = parser.parse_args()
    run(args)


if __name__ == '__main__':
    sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', buffering=1)
    main()
