#!/usr/bin/env python3

import argparse
import subprocess


def build_cmd(args):
    cmd = []
    cmd += [args.vnc_server]
    cmd += ['-geometry', args.geometry]
    cmd += ['-depth', args.depth]
    cmd += [f':{args.display_number}']

    return cmd


def run(args, cmd_arr):
    print(' '.join(cmd_arr))
    if args.execute:
        subprocess.run(cmd_arr)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--vnc-server', default='vncserver')
    parser.add_argument('-g', '--geometry', default='1280x800')
    parser.add_argument('-d', '--depth', default='24')
    parser.add_argument('-n', '--display-number', default=0)
    parser.add_argument('-e', '--execute', action='store_true')
    args = parser.parse_args()
    cmd_arr = build_cmd(args)
    run(args, cmd_arr)


if __name__ == '__main__':
    main()
