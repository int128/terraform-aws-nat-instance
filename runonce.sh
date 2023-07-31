#!/bin/bash -x

#The below is no longer needed.
# attach the ENI
#aws ec2 attach-network-interface \
#  --region "$(/opt/aws/bin/ec2-metadata -z  | sed 's/placement: \(.*\).$/\1/')" \
#  --instance-id "$(/opt/aws/bin/ec2-metadata -i | cut -d' ' -f2)" \
#  --device-index 1 \
#  --network-interface-id "${eni_id}"

# start SNAT
systemctl enable snat
systemctl start snat
