#!/bin/bash
set -x

# wait for eth1
while ! ip link show dev eth1; do
  sleep 1
done

# enable IP forwarding and NAT
sysctl -q -w net.ipv4.ip_forward=1
sysctl -q -w net.ipv4.conf.eth1.send_redirects=0
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# prevent setting the default route to eth0 after reboot
rm -f /etc/sysconfig/network-scripts/ifcfg-eth0

# switch the default route to eth1
ip route del default dev eth0

# wait for network connection
curl --retry 10 http://www.example.com

# reestablish connections
systemctl restart amazon-ssm-agent.service
