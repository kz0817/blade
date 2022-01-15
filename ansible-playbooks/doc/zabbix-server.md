# Create an LXD container for zabbix-server

## Launch
    NAME=zabbix-server
    lxc create images:debin/buster ${NAME}
    lxc config set ${NAME} security.nesting true

- Enabling 'security.nesting' is to allow zabix server to run bind mount.


## Install basic packages (in the contaienr)
    apt update
    apt upgrade
    apt install ansible

## Timezone (int the container)
    rm /etc/localtime
    echo Asia/Tokyo > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata

## Network
    lxc config device add ${NAME} eth1 nic nictype=bridged parent=br0 name=eth1

### Add a configuration file named `/etc/network/interfaces.d/eth1.cfg` like below
    auto eth1
    iface eth1 inet static
       address 192.168.0.10
       netmask 255.255.255.0

- Run `systemctl restart networking` to apply the above address.

## Attach a directory containing this repository
    lxc config device add zabbix-server blade disk source=/home/foo/blade path=/blade

# Setup software (in the container)
    cd /blade/ansible-playbooks
    ansible-playbook -i localhost, -c local zabbix-server.yml -e 'ansible_python_interpreter=/usr/bin/python3'


## Move Maria DB storage to the directory on a HDD to reduce write operations to SSD
Create the directory on the HOST machie

    ZABBIX_DATA_DIR=/store/zabbix-data
    mkdir ${ZABBIX_DATA_DIR}
    chmod o+w ${ZABBIX_DATA_DIR}
    lxc config device add ${NAME} data disk  source=${ZABBIX_DATA_DIR} path=/data

Move and link the Maria DB directory on the container

    mv /var/lib/mysql /data
    ln -s /data/mysql /var/lib/mysql
