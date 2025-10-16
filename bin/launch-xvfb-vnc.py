#!/usr/bin/env python3
import argparse
import os
import subprocess

HELP = '''

The following example launches Xvfb (-X, display :5), x11vnc (-V, port 5905), \
and noVNC (-N port 6905).

  launch-xvfb-vnc.py -W 1200 -H 720 -O 5 -X -V -N --novnc-bind-addr 0.0.0.0 --vnc-passwd ~/.vnc/passwd
 
'''

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

    cmd = [
        'x11vnc',
        '-display', f':{args.display_number}',
        '-forever',
        '-listen', f'{args.vnc_host_addr}',
        '-rfbport', f'{args.vnc_port}',
    ]

    if args.vnc_passwd:
        cmd += ['-rfbauth', args.vnc_passwd]

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


def launch_command_in_dbus_session(args):
    if not args.dbus_session:
        return

    cmd = ['dbus-run-session', '--'] + args.dbus_session

    print(cmd)
    env = os.environ.copy()
    env['DISPLAY'] = f':{args.display_number}'
    env['GTK_IM_MODULE'] = args.im_module
    env['QT_IM_MODULE'] =  args.im_module
    env['XMODIFIERS'] = f'@im={args.im_module}'

    proc = subprocess.Popen(cmd, env=env)


def run(args):
    launch_xvfb(args)
    launch_x11vnc(args)
    launch_no_vnc(args)
    launch_command_in_dbus_session(args)


def fixup_args(args):
    args.display_number += args.number_offset
    args.vnc_port += args.number_offset
    args.novnc_port += args.number_offset


def main():
    parser = argparse.ArgumentParser(
                formatter_class=argparse.RawDescriptionHelpFormatter,
                epilog=HELP)

    parser.add_argument('-O', '--number-offset', default=0, type=int)

    parser.add_argument('--display-number', default=0, type=int)
    parser.add_argument('--vnc-port', default=5900, type=int)
    parser.add_argument('--vnc-host-addr', default='localhost')
    parser.add_argument('--vnc-passwd',
                        help='a path to password file, which can be craeted by vncpasswd')

    parser.add_argument('--novnc-bind-addr', default='localhost')
    parser.add_argument('--novnc-port', default=6900, type=int)
    parser.add_argument('--novnc-web-dir', default='/usr/share/novnc')

    parser.add_argument('--im-module', default='fcitx')

    parser.add_argument('-W', '--width', default=1024, type=int)
    parser.add_argument('-H', '--height', default=768, type=int)
    parser.add_argument('-C', '--color-depth', default=24, type=int)

    parser.add_argument('-X', '--run-xvfb', action='store_true')
    parser.add_argument('-V', '--run-x11vnc', action='store_true')
    parser.add_argument('-N', '--run-novnc', action='store_true')
    parser.add_argument('-D', '--dbus-session', nargs='*', metavar='CMD',
                        help='a command in a new D-Bus session')

    args = parser.parse_args()
    fixup_args(args)
    run(args)


if __name__ == '__main__':
    main()
