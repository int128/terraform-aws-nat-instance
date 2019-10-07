#!/bin/bash -x

# Determine the region
export AWS_DEFAULT_REGION="$(/opt/aws/bin/ec2-metadata -z | sed 's/placement: \(.*\).$/\1/')"

# Attach the ENI
instance_id="$(/opt/aws/bin/ec2-metadata -i | cut -d' ' -f2)"
aws ec2 attach-network-interface \
    --instance-id "$instance_id" \
    --device-index 1 \
    --network-interface-id "${eni_id}"

# Wait for network initialization
sleep 10

# Enable IP forwarding and NAT
sysctl -q -w net.ipv4.ip_forward=1
sysctl -q -w net.ipv4.conf.eth1.send_redirects=0
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Switch the default route to eth1
ip route del default dev eth0

# Waiting for network connection
curl --retry 10 http://www.example.com

# Restart the SSM agent
systemctl restart amazon-ssm-agent.service

# Run the extra script if set
${extra_user_data}
