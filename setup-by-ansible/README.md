# How to use base.yml in a remote host

Copy this directory to the remote host. Then run the following commands in the remote hosts.

    apt install ansible
    ansible-playbook -i local, -c local base.yml

# Example to put public keys to /root/.ssh

    lxc exec foo mkdir -m 700 /root/.ssh
    lxc file push ~/.ssh/authroized_key foo/.ssh/ --uid 0 --gid 0

# Example to create user

    ansible-playbook -i hosts base.yml tags=user -e username=$USER -e uid=2001 -e gid=2001

Because they are defined in roles/user/defaults/main.yml, `uid` and `gid` can be omitted as

    ansible-playbook -i hosts base.yml tags=user -e username=$USER -uroot


