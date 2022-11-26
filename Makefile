.PHONY: fmt
fmt:
	cd modules/proxmox_kubernetes_cluster && terraform fmt
	cd modules/proxmox_ubuntu_vm && terraform fmt
	terraform fmt

.PHONY: test
test:
	terraform init
	terraform fmt -check
	terraform validate

.PHONY: plan
plan: test
	terraform plan

.PHONY: cluster
cluster: test
	terraform apply --auto-approve

.PHONY: destroy
destroy:
	terraform destroy