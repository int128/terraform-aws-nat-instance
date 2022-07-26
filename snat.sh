#!/bin/bash
set -x

# Wait for eth1
while ! ip link show dev eth1; do
  sleep 1
done

# Enable IP forwarding
sysctl -q -w net.ipv4.ip_forward=1

# Disable ICMP redirects on eth1
sysctl -q -w net.ipv4.conf.eth1.send_redirects=0

# Configure NAT
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Disable reverse path protection
for i in $(find /proc/sys/net/ipv4/conf/ -name rp_filter) ; do
  echo 0 > $i;
done

# prevent setting the default route to eth0 after reboot
rm -f /etc/sysconfig/network-scripts/ifcfg-eth0

# switch the default route to eth1
ip route del default dev eth0

# wait for network connection
curl --retry 10 http://www.example.com

# reestablish connections
systemctl restart amazon-ssm-agent.service