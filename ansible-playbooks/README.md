# How to install base packages

## Example via SSH

    ansible-playbook -i hosts base.yaml -u root

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

    ansible-playbook -i hosts base.yml tags=user -e username=$USER -e uid=2001 -e gid=2001

Here `uid` and `gid` can be omitted as below, because they are defined in roles/user/defaults/main.yml.

    ansible-playbook -i hosts base.yml tags=user -e username=$USER -u root

## If you don't copy ~/.ssh/authroized\_kesy
Add `skip_copy_auth_key=1` option. (In fact, the right hand side can be any value)

    ansible-playbook -i hosts base.yml tags=user -e username=$USER -u root -e skip_copy_auth_key=1


# Configuration for each users

Run the following commnad by the user.

    ansible-playbook -i hosts home.yml

Keep in mind that
- SSH agent forwarding be enabled
- python3 and git pakcages be installed
