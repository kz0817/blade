# Install basic programs

    apk add openssh
    rc-status add openssh
    /etc/init.d/sshd start

    # The following key setting is needed to configure with ansible
    adduser <user_name>
    mkdir /home/<user_name>/.ssh
    <place public keys as .ssh/au/thorized_keys>

    <create /etc/sudoers.d/<user_name>-nopasswd with the following content>
    <user_name> ALL=(ALL:ALL) NOPASSWD:ALL

    apk add python3
    apk add sudo
