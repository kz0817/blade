#!/usr/bin/env python3
import argparse
import os
import shutil
import subprocess

class Context:
    def __init__(self, args):
        self.args = args
        self.swtpm = None

    def stop_swtpm(self):
        if self.swtpm is None:
            return
        print('Stop SWTPM')
        self.swtpm.terminate()
        print('  -> Done')

    def cleanup(self):
        self.stop_swtpm()


def prepare_ovmf(ctx):
    if os.path.isfile(ctx.args.ovmf_local_vars):
        print('Found: OVMF VARS file')
        return

    shutil.copy(ctx.args.ovmf_vars, ctx.args.ovmf_local_vars)
    print('Copied: OVMF VARS file')


def launch_swtpm(ctx):
    if os.path.isfile(ctx.args.swtpm_sock):
       raise RuntimeError('SWTPM socket is existing')

    cmd = (
        'swtpm', 'socket',
        '--tpmstate', f'dir={ctx.args.swtpm_state_dir}',
        '--ctrl', f'type=unixio,path={ctx.args.swtpm_sock}',
        '--tpm2')
    ctx.swtpm = subprocess.Popen(cmd)
    print('Launched: SWTPM')


def prepare(ctx):
    prepare_ovmf(ctx)
    launch_swtpm(ctx)


def generate_base_qemu_command(ctx):
    args = ctx.args
    cmd = [
        'qemu-system-x86_64', '-enable-kvm',
        '-cpu', 'host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time',
        '-smp', f'cores={args.cores},threads=1,sockets=1',
        '-m', f'{args.memory}',
        '-machine', 'q35',
        '-device', 'qemu-xhci,id=usb-bus',
        '-drive', f'if=pflash,format=raw,readonly=on,file={args.ovmf_code}',
        '-drive', f'if=pflash,format=raw,file={args.ovmf_local_vars}',
        '-device', 'virtio-balloon-pci',
        '-device', 'virtio-rng-pci',
        '-chardev', f'socket,id=chrtpm,path={args.swtpm_sock}',
        '-tpmdev', 'emulator,id=tpm0,chardev=chrtpm',
        '-device', 'tpm-tis,tpmdev=tpm0',
        '-device', 'virtio-gpu-pci',
        '-display', 'gtk,gl=on',
        '-device', 'virtio-net-pci,netdev=net0',
        '-netdev', 'user,id=net0',
        '-drive', f'file={args.drive},if=virtio,format=qcow2',
    ]
    return cmd


def install(ctx):
    args = ctx.args
    cmd = generate_base_qemu_command(ctx) + [
        '-drive', f'file={args.installer},format=raw,if=none,id=installer',
        '-device', 'usb-storage,drive=installer,bootindex=1',
        '-drive', f'file={args.virtio_iso},index=1,media=cdrom',
        '-boot', 'd',
    ]
    subprocess.run(cmd, check=True)


def boot(ctx):
    args = ctx.args
    cmd = generate_base_qemu_command(ctx)
    subprocess.run(cmd, check=True)


def run(ctx):
    prepare(ctx)

    command = ctx.args.command
    if command is None:
        command = 'boot'

    if command == 'install':
        install(ctx)
    elif command == 'boot':
        boot(ctx)
    else:
        print(f'Unknown command: {command}')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--ovmf-code', default='/usr/share/OVMF/OVMF_CODE_4M.ms.fd')
    parser.add_argument('--ovmf-vars', default='/usr/share/OVMF/OVMF_VARS_4M.ms.fd')
    parser.add_argument('--ovmf-local-vars', default='OVMF_VARS_4M.fd')
    parser.add_argument('--swtpm-sock', default='tpm.sock')
    parser.add_argument('--swtpm-state-dir', default='./')
    parser.add_argument('-c', '--cores', type=int, default=4)
    parser.add_argument('-m', '--memory', default='8G')
    parser.add_argument('drive')

    sub_parsers = parser.add_subparsers(dest='command')
    parser_installer = sub_parsers.add_parser('install')
    parser_installer.add_argument('installer')
    parser_installer.add_argument('virtio_iso')

    args = parser.parse_args()
    ctx = Context(args)
    try:
        run(ctx)
    finally:
        ctx.cleanup()


if __name__ == '__main__':
    main()
