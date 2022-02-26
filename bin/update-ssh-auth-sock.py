#!/usr/bin/env python3
import os
import re
import argparse
import sys

HELP_DESCENDENT_PID = '''
search sshd or ssh-agent from the process with the given PID and its ancestors
(parent, grand parent, ...)
'''

def put_to_stderr(msg):
    sys.stderr.write(msg + '\n')

def verbose_msg(args, msg):
    if not args.verbose:
        return
    put_to_stderr(msg)


def error_msg(msg):
    put_to_stderr(msg)


def get_name_and_parent_pid(pid):
    with open("/proc/%s/stat" % pid) as f:
        elem_arr = f.read().split()
        if len(elem_arr) < 4:
            return None
        return elem_arr[1][1:-1], elem_arr[3]


def get_ancestors(pid):
    ancestors = []
    while (True):
        cmd_name, parent_pid = get_name_and_parent_pid(pid)
        if parent_pid is None:
            break
        ancestors.append((cmd_name, pid, parent_pid))
        if parent_pid == "1":
            break
        pid = parent_pid
    return ancestors


def find_my_process(command, need_parent_pid=False):
    re_proc_name = re.compile(r"^\d+$")
    entries = os.listdir("/proc")
    my_uid = os.getuid()
    for dirname in filter(lambda x: re_proc_name.match(x), entries):
        path = os.path.join("/proc", dirname)
        st = os.stat(path)
        if st.st_uid != my_uid:
             continue
        cmd_name, parent_pid = get_name_and_parent_pid(dirname)
        if cmd_name != command:
            continue
        yield parent_pid if need_parent_pid else dirname


def get_ssh_auth_socks():
    re_agent_name = re.compile(r"agent\.\d+$")
    base_dir = os.path.join("/tmp")
    for name in os.listdir(base_dir):
        if name[0:4] != "ssh-":
            continue
        agent_dir = os.path.join(base_dir, name)
        if not os.path.isdir(agent_dir):
            continue
        agent_candidates = os.listdir(agent_dir)
        for a in filter(lambda x: re_agent_name.match(x), agent_candidates):
            yield a[len("agent."):], os.path.join(agent_dir, a)

def get_anscestore_sshd_pids(descendent_pid):
    sshd_pids = set()
    for cmd, pid, parent_pid in get_ancestors(descendent_pid):
        if cmd == "sshd":
            sshd_pids.add(pid)
        elif cmd == "ssh-agent":
            sshd_pids.add(parent_pid)
    return sshd_pids


def get_sshd_pids_from_all():
    sshd_pids = set()
    sshd_pids.update(list(find_my_process("sshd")))
    sshd_pids.update(list(find_my_process("ssh-agent", need_parent_pid=True)))
    return sshd_pids

def show_result(args, path):
    print('export SSH_AUTH_SOCK=%s' % path)
    print('if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then')
    print('  screen -X setenv SSH_AUTH_SOCK %s' % path)
    print('fi')

def main(args):
    if args.descendent_pid:
        sshd_pids = get_anscestore_sshd_pids(args.descendent_pid)
    else:
        sshd_pids = get_sshd_pids_from_all()

    verbose_msg(args, "found: sshd or ssh-agent PIDs: %s" % sshd_pids)

    for pid, path in get_ssh_auth_socks():
        verbose_msg(args, "-> auth sock: %s" % path)
        if pid not in sshd_pids:
            continue
        show_result(args, path)
        break
    else:
        error_msg("Failed to find ssh auth sock.")
        return -1

def start():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--descendent-pid', type=int, help=HELP_DESCENDENT_PID)
    parser.add_argument('-v', '--verbose', action='store_true')

    args = parser.parse_args()
    main(args)


if __name__ == "__main__":
    start()
