# Assign an IP address

    ip addr add 192.168.1.100/24 dev eth0

# Remove an IP address

    ip addr del 192.168.1.100/24 dev eth0

# Remove all the IPv4 address for the device

    ip -4 addr flush dev eth0
