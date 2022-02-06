#!/usr/bin/env python3
import argparse
import re
import time
import sys
import os
import math


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


def show_cpu_load(args, prev_cpu_load_set, curr_cpu_load_set):
    num_cpu = len(curr_cpu_load_set)
    assert len(prev_cpu_load_set) == num_cpu

    s = 'CPU '
    for idx in range(num_cpu):
        s += show_each_cpu_load(args, prev_cpu_load_set[idx], curr_cpu_load_set[idx])
    print(s)


def show(args, prev_data, curr_data):
    if prev_data is None:
        return
    show_cpu_load(args, prev_data.cpu_load_set, curr_data.cpu_load_set)


def run(args):
    prev_data = None
    while True:
        cpu_load_set = get_cpu_load()
        curr_data = Data(cpu_load_set)
        show(args, prev_data, curr_data)
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