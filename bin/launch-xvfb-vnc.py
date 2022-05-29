#!/usr/bin/env python3
import argparse
import subprocess


def launch_xvfb(args):
    if not args.run_xvfb:
        return

    cmd = (
        'Xvfb',
        f':{args.display_number}',
        '-screen', '0',
        f'{args.width}x{args.height}x{args.color_depth}',
    )
    print(cmd)
    proc = subprocess.Popen(cmd)


def launch_x11vnc(args):
    if not args.run_x11vnc:
        return

    cmd = (
        'x11vnc',
        '-display', f':{args.display_number}',
        '-forever',
        '-usepw',
        '-listen', f'{args.vnc_host_addr}',
        '-rfbport', f'{args.vnc_port}',
    )
    print(cmd)
    proc = subprocess.Popen(cmd)


def launch_no_vnc(args):
    if not args.run_novnc:
        return

    cmd = [
        'websockify',
    ]

    if args.novnc_web_dir is not None:
        cmd += ['--web', args.novnc_web_dir]

    cmd += [
        f'{args.novnc_bind_addr}:{args.novnc_port}',
        f'{args.vnc_host_addr}:{args.vnc_port}',
    ]
    print(cmd)
    proc = subprocess.Popen(cmd)


def run(args):
    launch_xvfb(args)
    launch_x11vnc(args)
    launch_no_vnc(args)


def fixup_args(args):
    args.display_number += args.number_offset
    args.vnc_port += args.number_offset
    args.novnc_port += args.number_offset


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('-O', '--number-offset', default=0, type=int)

    parser.add_argument('--display-number', default=0, type=int)
    parser.add_argument('--vnc-port', default=5900, type=int)
    parser.add_argument('--vnc-host-addr', default='localhost')

    parser.add_argument('--novnc-bind-addr', default='localhost')
    parser.add_argument('--novnc-port', default=6900, type=int)
    parser.add_argument('--novnc-web-dir')

    parser.add_argument('-W', '--width', default=1024, type=int)
    parser.add_argument('-H', '--height', default=768, type=int)
    parser.add_argument('-C', '--color-depth', default=24, type=int)

    parser.add_argument('-X', '--run-xvfb', action='store_true')
    parser.add_argument('-V', '--run-x11vnc', action='store_true')
    parser.add_argument('-N', '--run-novnc', action='store_true')

    args = parser.parse_args()
    fixup_args(args)
    run(args)


if __name__ == '__main__':
    main()
