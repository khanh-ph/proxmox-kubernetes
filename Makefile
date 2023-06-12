fmt: 
	terraform fmt --recursive

fmt-check:
	terraform fmt -check --recursive

init:
	terraform init -backend=false -input=false

test: fmt-check init
	terraform validate

deploy:
	source .env.$(env) && terraform init -upgrade && terraform apply

destroy:
	source .env.$(env) && terraform init -upgrade && terraform destroy

cluster: test
	terraform apply -var-file="example.tfvars"

.PHONY: fmt fmt-check init test deploy destroy