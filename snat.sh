#!/bin/bash
set -x

# wait for eth1
end_time=$((SECONDS + 180))
while [ $SECONDS -lt $end_time ] && ! ip link show dev eth1; do
  sleep 1
done

if ! ip link show dev eth1; then
  exit 1
fi

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
