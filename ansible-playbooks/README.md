# How to install base packages

## Example via SSH

    ansible-playbook -i hosts base.yml -u root

The following options can be used.
- -u: loing user
- -k: Ask password to login
- -K: Ask password for sudo. This option can be omitted when the user becomes root w/o password.
- -b: Run with sudo

`hosts.example` can be used as a templete for `hosts`

## Example via a local channel (in a target host)

Copy this directory to the target host. Then run the following commands in the target machine.

    apt install ansible
    ansible-playbook -i local, -c local base.yml

### Example to put public keys to /root/.ssh for an LXD host

    lxc exec foo mkdir -m 700 /root/.ssh
    lxc file push ~/.ssh/authroized_key foo/.ssh/ --uid 0 --gid 0


# Example to create user

    ansible-playbook -i hosts base.yml --tags=user -e username=$USER -e uid=2001 -e gid=2001

`uid` and `gid` can be omitted as below. In this case, values defined in roles/user/defaults/main.yml are used.

    ansible-playbook -i hosts base.yml --tags=user -e username=$USER -u root

## If you copy ~/.ssh/authroized\_kesy
Add `copy_ssh_auth_key=true` or `copy_ssh_auth_key=1` like

    ansible-playbook -i hosts base.yml --tags=user -e username=$USER -u root -e copy_ssh_auth_key=1

## If you download SSH authorized keys from Github
Add `github_name_for_ssh_auth_key=NAME` like

    ansible-playbook -i hosts base.yml --tags=user -e username=$USER -u root -e github_name_for_ssh_auth_key=myname

Note: When .ssh/authrozied\_keys is already placed, this option doesn't try to download if keys on Github are updated.


# Configuration for each users

Run the following commnad by the user.

    ansible-playbook -i hosts home.yml

Keep in mind that
- SSH agent forwarding be enabled
- python3 and git pakcages be installed
- Try to pass `-e 'ansible_python_interpreter=/usr/bin/python2'` when OSError happens
