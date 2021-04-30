#!/usr/bin/env python3
import argparse
import os
import subprocess
import time

DEFAULT_PRODUCT="ARCHISS PTR66"

def read_content(path):
    with open(path) as f:
        return f.read()


def write(path, content):
    with open(path, 'w') as f:
        f.write(content)


def get_usb_addr(args):
    usb_dev_dir = '/sys/bus/usb/devices'
    dir_entries = os.listdir(usb_dev_dir)
    for entry in dir_entries:
        path = os.path.join(usb_dev_dir, entry, 'product')
        if not os.path.isfile(path):
            continue
        product = read_content(path).strip()
        if product == args.product:
            return entry

    raise RuntimeError(f'Not found: {args.product}')


def do_bind(addr, cmd_type):
    DRIVER_PATH = '/sys/bus/usb/drivers/usb'
    cmd_unbind = ['sudo', 'sh', '-c',
                  f'echo -n {addr} > {DRIVER_PATH}/{cmd_type}']
    cp = subprocess.run(cmd_unbind)
    print(f'{cmd_type}: return code: {cp.returncode}')

def bind(addr):
    do_bind(addr, 'bind')

def unbind(addr):
    do_bind(addr, 'unbind')

def run(args):

    addr = get_usb_addr(args)
    print(f'Found {args.product}: {addr}')
    if args.dry_run:
        return

    unbind(addr)

    print(f'Sleep {args.sleep_time} sec')
    time.sleep(args.sleep_time)

    bind(addr)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--product', default=DEFAULT_PRODUCT)
    parser.add_argument('-s', '--sleep-time', default=3, type=float)
    parser.add_argument('-n', '--dry-run', action='store_true')
    args = parser.parse_args()
    run(args)


if __name__ == '__main__':
    main()
