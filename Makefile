all: check README.md

.PHONY: check
check:
	terraform fmt -check=true -diff=true
	terraform init
	AWS_REGION=us-east-1 terraform validate
	make -C example check

README.md: variables.tf outputs.tf
	sed -e '/^<!--terraform-docs-->/q' $@ > $@.tmp
	terraform-docs md . >> $@.tmp
	mv $@.tmp $@
