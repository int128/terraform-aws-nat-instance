#!/bin/bash -x

sudo yum install -y jq

INSTANCE_ID="$(/opt/aws/bin/ec2-metadata -i | cut -d' ' -f2)"
REGION="$(/opt/aws/bin/ec2-metadata -z  | sed 's/placement: \(.*\).$/\1/')"

# attach the ENI
aws ec2 attach-network-interface \
  --region "$REGION" \
  --instance-id "$INSTANCE_ID" \
  --device-index 1 \
  --network-interface-id "${eni_id}"

# Disable source/destination checks
for i in $(aws ec2 describe-instances --region "$REGION" --filter '[{"Name": "instance-id", "Values": ["'$INSTANCE_ID'"]}]' | jq -r .Reservations[0].Instances[0].NetworkInterfaces[].NetworkInterfaceId); do
  aws ec2 modify-network-interface-attribute \
    --region "$REGION" \
    --network-interface-id "$i" \
    --no-source-dest-check
done

# start SNAT
systemctl enable snat
systemctl start snat
