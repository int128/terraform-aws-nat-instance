all: check README.md

.PHONY: check
check:
	terraform fmt -check=true -diff=true
	AWS_REGION=us-east-1 terraform validate

README.md: variables.tf outputs.tf
	sed -e '/^<!--terraform-docs-->/q' $@ > $@.tmp
	terraform-docs --with-aggregate-type-defaults md variables.tf outputs.tf >> $@.tmp
	mv $@.tmp $@
