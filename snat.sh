#!/bin/bash -x

# wait for eth1
while ! ip link show dev eth1; do
  sleep 1
done

sysctl -q -w net.ipv4.conf.all.rp_filter=0
sysctl -q -w net.ipv4.conf.eth0.rp_filter=0
sysctl -q -w net.ipv4.conf.eth1.rp_filter=0
sysctl -q -w net.ipv4.conf.default.rp_filter=0


# enable IP forwarding and NAT
sysctl -q -w net.ipv4.ip_forward=1
sysctl -q -w net.ipv4.conf.eth1.send_redirects=0
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# wait for network connection
curl --retry 10 http://www.example.com

# reestablish connections
systemctl restart amazon-ssm-agent.service
