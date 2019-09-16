# Create an LXD container for zabbix-server

## Launch

    lxc create images:debin/buster zabbix-server
    lxc config set zabbix-server security.privileged true

## Install basic packages

    apt update
    apt upgrade
    apt install ansible

## Timezone

    rm /etc/localtime
    echo Asia/Tokyo > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata

## Network

    lxc config device add zabbix-server eth1 nic nictype=bridged parent=br0

Add a configuration file named `/etc/network/interfaces.d/eth1.cfg`

```
auto eth1
iface eth1 inet static
   address 192.168.0.10
   netmask 255.255.255.0
```

## Attach a directory containing this repository

    lxc config device add zabbix-server priv-misc disk source=/home/foo/priv-misc path=/priv-misc


# Run command in the container

    cd /priv-misc/setup-by-ansible
    ansible-playbook -i local, -c local zabbix-server.yml -e 'ansible_python_interpreter=/usr/bin/python3'
