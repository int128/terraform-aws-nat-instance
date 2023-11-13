#!/bin/bash -x

# attach the ENI
end_time=$((SECONDS + 180))
while [ $SECONDS -lt $end_time ] && ! ip link show dev eth1; do
  aws ec2 attach-network-interface \
    --region "$(/opt/aws/bin/ec2-metadata -z  | sed 's/placement: \(.*\).$/\1/')" \
    --instance-id "$(/opt/aws/bin/ec2-metadata -i | cut -d' ' -f2)" \
    --device-index 1 \
    --network-interface-id "${eni_id}"
    sleep 1
done

# start SNAT
systemctl enable snat
systemctl start snat
