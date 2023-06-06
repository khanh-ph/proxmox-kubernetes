ks_img ?= khanhphhub/kubespray:v2.22.0
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
	@terraform init -input=false

test: init $(modules:%=%/fmt_check)
	@terraform fmt -check
	@terraform validate

%/fmt_check:
	@cd $* && terraform fmt -check

plan: test
	@terraform plan -input=false

destroy:
	@terraform destroy

infra: test
	@terraform apply -input=false --auto-approve -var ks_tmp=$(ks_tmp)

k8s:
	@docker pull $(ks_img)
	@sudo chmod 600 $(ks_tmp)/id_rsa
	@docker run --rm \
	--mount type=bind,source="${ks_tmp_abspath}/inventory.ini",dst=/inventory/sample/inventory.ini \
	--mount type=bind,source="${ks_tmp_abspath}/addons.yml",dst=/inventory/sample/group_vars/k8s_cluster/k8s-cluster.yml \
	--mount type=bind,source="${ks_tmp_abspath}/k8s-cluster.yml",dst=/inventory/sample/group_vars/k8s_cluster/addons.yml \
	--mount type=bind,source="${ks_tmp_abspath}/id_rsa",dst=/root/.ssh/id_rsa \
	$(ks_img) bash -c \
	"ansible-playbook -i /inventory/sample/inventory.ini -u ubuntu -become cluster.yml"

cluster: infra k8s clean

clean: $(needs_cleanup:%=%/clean)

%/clean:
	@sudo rm -rf $*

.PHONY: fmt init test plan destroy infra k8s cluster clean kubectl
.PHONY: %/fmt %/fmt_check %/clean
