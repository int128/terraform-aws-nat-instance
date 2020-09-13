.PHONY: check
check:
	terraform fmt -check=true -diff=true
	terraform init
	AWS_REGION=us-east-1 terraform validate
