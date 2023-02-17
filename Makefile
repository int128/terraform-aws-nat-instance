.PHONY: check
check:
	terraform fmt
	terraform init
	AWS_REGION=us-east-1 terraform validate
	make -C example check
