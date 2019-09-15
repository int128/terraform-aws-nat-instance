all: check README.md

.PHONY: check
check:
	terraform fmt -check=true -diff=true
	AWS_REGION=us-east-1 terraform validate \
		-var name=nat \
		-var vpc_id=vpc-XXXXXXXX \
		-var public_subnet=subnet-XXXXXXXX \
		-var private_subnets_cidr_blocks=172.18.0.0/20

README.md: variables.tf outputs.tf
	sed -e '/^\/\/terraform-docs/q' $@ > $@.tmp
	terraform-docs md variables.tf outputs.tf >> $@.tmp
	mv $@.tmp $@
