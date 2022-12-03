ks_img ?= quay.io/ulagbulag-village/kubespray:latest
ks_tmp = kubespray/tmp
ks_tmp_abspath= $(abspath $(ks_tmp))
modules := $(wildcard modules/*)
needs_cleanup := $(ks_tmp)

export TF_IN_AUTOMATION := true

fmt: $(modules:%=%/fmt)
	@terraform fmt

%/fmt:
	@cd $* && terraform fmt

init:
	@terraform init

test: init $(modules:%=%/fmt_check)
	@terraform fmt -check
	@terraform validate

%/fmt_check:
	@cd $* && terraform fmt -check

plan: test
	@terraform plan

destroy:
	@terraform destroy

infra: test
	@terraform apply --auto-approve -var ks_tmp=$(ks_tmp)

ks_img:
	@docker pull $(ks_img)

k8s: ks_img
	@echo ${TF_VAR_ansible_private_key} | base64 --decode > $(ks_tmp)/id_rsa
	@sudo chmod 600 $(ks_tmp)/id_rsa
	@docker run --rm -it \
	--mount type=bind,source="${ks_tmp_abspath}/inventory.ini",dst=/inventory/sample/inventory.ini \
	--mount type=bind,source="${ks_tmp_abspath}/addons.yml",dst=/inventory/sample/group_vars/k8s_cluster/k8s-cluster.yml \
	--mount type=bind,source="${ks_tmp_abspath}/k8s-cluster.yml",dst=/inventory/sample/group_vars/k8s_cluster/addons.yml \
	--mount type=bind,source="${ks_tmp_abspath}/id_rsa",dst=/root/.ssh/id_rsa \
	$(ks_img) bash -c \
	"ansible-playbook -i /inventory/sample/inventory.ini -u ubuntu -become cluster.yml"

cluster: infra k8s clean

clean: $(needs_cleanup:%=%/clean)

%/clean:
	@rm -rf $*

.PHONY: fmt init test plan destroy infra kubespray_image k8s cluster clean
.PHONY: %/fmt %/fmt_check %/clean
