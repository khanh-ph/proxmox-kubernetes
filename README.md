## About the project

An Infrastructure as Code (IaC) project to create a Kubernetes cluster on [Proxmox VE](https://pve.proxmox.com/wiki/Main_Page) using [Terraform](https://www.terraform.io/) and [Kubespray](https://github.com/kubernetes-sigs/kubespray).

![Proxmox Kubernetes clusters](proxmox-kubernetes.png)

## Terminology

Throughout the guide, the term `deployment agent` is used to mean the machine where we trigger the deployment. It could be your local machine or any CI/CD agent (Jenkins agent, Octopus Deploy worker, etc).

## Getting started

### Prerequisites

* Virtualization management:
    * Proxmox Virtual Environment `>=7.3.3`
    * An Ubuntu 22.04 VM template on Proxmox VE. You may need to create one following [the instruction on how to create an Ubuntu VM template on Proxmox](https://github.com/khanh-ph/proxmox-scripts/tree/master/create-vm-template).

* Deployment agent:
    * Terraform `>=1.3.3`
    * GNU Make
    * Docker (for Linux)

### Usage

1. Clone the repo:

    ```sh
    # Clone the repo
    git clone https://github.com/khanh-ph/proxmox-kubernetes.git
    cd proxmox-kubernetes
    ```

3. Set up the required environment variables:
    ```sh
    # Set parallelism=1 while running terraform apply. 
    # This is to prevent errors on Proxmox concurrent operations.
    export TF_CLI_ARGS_apply="-parallelism=1"

    # Your Proxmox API URL. For e.g: https://PROXMOX_IP_ADDRESS:8006/api2/json
    export TF_VAR_pm_api_url=PROXMOX_API_URL

    # Your Proxmox API Token ID and Secret.
    export TF_VAR_pm_api_token_id=PROXMOX_API_TOKEN_ID
    export TF_VAR_pm_api_token_secret=PROXMOX_API_TOKEN_SECRET

    # Specify whether you want to disable the TLS verification while connecting to your Proxmox API server. 
    # In the local/private network for test/dev environment, `true` is just fine.
    # Before setting it to `false`, you need to have TLS termination configured somewhere in front of your Proxmox API server.
    # Another the option the keep the connection from client to Proxmox API server secured is to import the Proxmox CA cert to your client.
    export TF_VAR_pm_tls_insecure=true

    # Your Proxmox node hostname where the Guest VM will be placed
    export TF_VAR_pm_host=PROXMOX_NODE_HOSTNAME

    # Your Proxmox storage ID where the Guest VM disks will be allocated; E.g: local-zfs, local-lvm
    export TF_VAR_vm_disk_storage=PROXMOX_STORAGE_ID

    # The SSH public keys for SSH key-based authentication to all cluster VMs. 
    # You are free to generate your key-pairs, encode the SSH public keys with base64 then put it here.
    # On local machine, you may simply use the public key of the current user as following:
    export TF_VAR_base64_vm_authorized_keys=$(cat ~/.ssh/id_rsa.pub | base64)

    # The SSH private key used by Ansible (Kubespray) for SSH key-based authentication.
    # You are free to generate your key-pair, encode the private key with base64 then put it here. 
    # Important: this private key should be in the same key-pair with at least 
    # one of the public keys specified in `TF_VAR_base64_vm_authorized_keys`.
    # On local machine, you may simply use the private key of the current user as following:
    export TF_VAR_base64_ansible_private_key=$(cat ~/.ssh/id_rsa | base64)`
    ```

3. Start the deployment:
    ```sh
    make cluster
    ```

4. Once the deployment is complete, it's time to try `kubectl`:
    ```sh
    ssh CONTROL_PLANE_IP
    sudo kubectl get all -A
    ```

#### Configurations

Environment variables in the format `TF_VAR_name` can be used to set Terraform variables. Please look into `*-vars.tf` files for usage.

Below is the list of available options:

##### Scaling

* TF_VAR_control_plane_node_count
* TF_VAR_worker_node_count
* TF_VAR_vm_os_disk_size_gb
* TF_VAR_vm_memory_mb
* TF_VAR_vm_cpus

##### Kubernetes configurations

* TF_VAR_cluster_name
* TF_VAR_kube_version
* TF_VAR_kube_network_plugin
* TF_VAR_enable_nodelocaldns
* TF_VAR_podsecuritypolicy_enabled
* TF_VAR_persistent_volumes_enabled
* TF_VAR_helm_enabled
* TF_VAR_ingress_nginx_enabled
* TF_VAR_argocd_enabled
* TF_VAR_argocd_version

##### Deploy Kubernetes cluster on a private network

* TF_VAR_vm_net_use_dhcp
* TF_VAR_vm_net_bridge
* TF_VAR_vm_net_cidr
* TF_VAR_bastion_ssh_ip
* TF_VAR_bastion_ssh_user
* TF_VAR_bastion_ssh_port

## Blog posts

* [Create a Kubernetes cluster on Proxmox using Terraform and Kubespray](https://www.khanhph.com/install-proxmox-kubernetes/)