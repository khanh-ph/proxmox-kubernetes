## About the project

`Pineapple-cluster` is an Infrastructure as Code (IaC) project to build up a Kubernetes cluster on [Proxmox VE](https://pve.proxmox.com/wiki/Main_Page) using [Terraform](https://www.terraform.io/) and [Kubespray](https://github.com/kubernetes-sigs/kubespray).

## Getting started

### Prerequisites

Before we start, make sure you have the following things in place:

1. Virtualization Environment:

    * **Proxmox Virtual Environment**<br>
    _This is an open-source server virtualization management solution in which you can create and manage VMs, container and HA clusters, etc. To begin with, you can install [Proxmox VE](https://pve.proxmox.com/wiki/Main_Page) on either a dedicated server or a VM with virtualization enabled._

2. Tools on your CI/CD agent or local machine where to trigger the deployment:

    * **Terraform CLI** <br>
    _[Terraform](https://www.terraform.io/) is an IaC tool that allows you to build, change and version cloud and on-prem resources efficiently. Getting the Terraform CLI ready is an essential part of this project._
    * **Make** <br>
    _[GNU Make](https://www.gnu.org/software/make/) is required to take advantage of pre-defined recipes in `Makefile`._
    * **Docker (for Linux)** <br>
    _We would need Docker to run [Kubespray](https://github.com/kubernetes-sigs/kubespray) container image. The image is shipped with Ansible, Python and a bunch of Ansible playbooks which are needed to build up a production-ready Kubernetes cluster._

### Installation

1. On your Proxmox VE server:
    * Run the below script to create an Ubuntu 22.04 VM template:
        ```sh
        curl -s https://raw.githubusercontent.com/khanh-ph/proxmox-scripts/master/create-cloud-init-VM-template.sh | sudo bash
        ```
    * Verify if the template `ubuntu-2204` is created:
        ```sh
        sudo qm list | grep ubuntu
        ```

2. On the machine where you start the deployment (CI/CD agent, local machine):

    * Clone the repo
        ```sh
        git clone https://github.com/khanh-ph/pineapple-cluster.git
        ```
    * Set the required environment variables:
        ```sh
        # Set parallelism=1 while running terraform apply. This is to prevent errors on Proxmox concurrent operations.
        export TF_CLI_ARGS_apply="-parallelism=1"

        # Your Proxmox API URL. For e.g: https://PROXMOX_IP_ADDRESS:8006/api2/json
        export TF_VAR_pm_api_url=PROXMOX_API_URL
        
        # Your Proxmox API Token ID and Secret.
        export TF_VAR_pm_api_token_id=PROXMOX_API_TOKEN_ID
        export TF_VAR_pm_api_token_secret=PROXMOX_API_TOKEN_SECRET
        
        # Specify whether you want to disable the TLS verification while connecting to your Proxmox API server. 
        # In testing environment, `true` is just fine.
        export TF_VAR_pm_tls_insecure=true
        
        # Your Proxmox node hostname where the Guest VM will be placed
        export TF_VAR_pm_host=PROXMOX_NODE_HOSTNAME
        
        # Your Proxmox storage ID where the Guest VM disks will be allocated; E.g: local-zfs, local-lvm
        export TF_VAR_vm_disk_storage=PROXMOX_STORAGE_ID

        # The SSH public key of the Ansible or Bastion host for SSH key-based authentication. This key will be copied to all the VMs.
        # You are free to generate your key-pair then put here the SSH public key.
        # On local machine, you may simply assign the public key of the current user as following:
        export TF_VAR_vm_authorized_keys=$(cat ~/.ssh/id_rsa.pub)

        # The SSH private key used by Ansible / Kubespray for SSH key-based authentication.
        # You are free to generate your key-pair, encode the private key with base64 then put it here. 
        # Be noted that the private key should be in the same key-pair with at least one of the public keys specified in `TF_VAR_vm_authorized_keys` 
        # On local machine, you may simply use the private key of the current user as following:
        export TF_VAR_ansible_private_key_base64=$(cat ~/.ssh/id_rsa | base64)
        ```

### Usage

On your local machine, create your Kubernetes cluster with a single command:
```sh
make cluster
```

#### Configuration

Environment variables in the format `TF_VAR_name` can be used to set Terraform variables. Please look into `*-vars.tf` files for usage.

Below is the list of available options:

##### Infra (kube-infra-vars.tf)

* TF_VAR_cluster_name
* TF_VAR_control_plane_node_count
* TF_VAR_worker_node_count
* TF_VAR_vm_os_disk_size_gb
* TF_VAR_vm_memory_mb
* TF_VAR_vm_cpus

##### Kubernetes (kube-config-vars.tf)

* TF_VAR_kube_version
* TF_VAR_kube_network_plugin
* TF_VAR_enable_nodelocaldns
* TF_VAR_podsecuritypolicy_enabled
* TF_VAR_persistent_volumes_enabled
* TF_VAR_helm_enabled
* TF_VAR_ingress_nginx_enabled
* TF_VAR_argocd_enabled
* TF_VAR_argocd_version