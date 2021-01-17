#!/usr/bin/env python3
import argparse
import re
import time

def search(args, lines):
    for line in lines:
        if args.dev_reg.search(line):
            yield line


def show_one_dev(line):
    words = line.split()
    rx_bytes = float(words[1])
    tx_bytes = float(words[9])
    rx_mib = rx_bytes / (2**20)
    tx_mib = tx_bytes / (2**20)
    print(f'{words[0]} Rx: {rx_mib:.1f}, Tx: {tx_mib:.1f} (MiB)')


def show(dev_lines):
    for line in dev_lines:
        show_one_dev(line)


def get_dev_stat(args):
    with open('/proc/net/dev', 'r') as f:
        return f.readlines()


def run(args):
    args.dev_reg = re.compile(f'^{args.dev}:')

    while True:
        lines = get_dev_stat(args)
        show(search(args, lines))
        time.sleep(args.interval)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--interval', default=10, type=float)
    parser.add_argument('dev')
    args = parser.parse_args()
    run(args)

if __name__ == '__main__':
    main()
