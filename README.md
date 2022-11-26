## About the project

`Pineapple-cluster` is an Infrastructure as Code (IaC) project to build up a Kubernetes cluster on [Proxmox VE](https://pve.proxmox.com/wiki/Main_Page) using [Terraform](https://www.terraform.io/).

## Getting started

### Prerequisites

Before we start, make sure you have the following things in place:

* **Proxmox Virtual Environment (required)**<br>
_This is an open-source server virtualization management solution in which you can create and manage VMs, container and HA clusters, etc. To begin with, you can install [Proxmox VE](https://pve.proxmox.com/wiki/Main_Page) on either a dedicated server or a VM with virtualization enabled._
* **Terraform CLI (required)**<br>
_[Terraform](https://www.terraform.io/) is an IaC tool that allows you to build, change and version cloud and on-prem resources efficiently. Getting the Terraform CLI ready on your local machine is an essential part of this project._
* **Make (optional)**<br>
_`GNU Make` is recommended to take advantage of pre-defined recipes in `Makefile`_

### Installation

1. On Proxmox VE server:
    * Run the below script to build an Ubuntu VM template:
        ```sh
        curl -s https://raw.githubusercontent.com/khanh-ph/proxmox-scripts/master/create-cloud-init-VM-template.sh | sudo bash
        ```
    * Verify if the template `ubuntu-2004-cloudinit-minimal` is created:
        ```sh
        sudo qm list | grep cloudinit
        ```

2. On your local machine:

    * Clone the repo
        ```sh
        git clone https://github.com/khanh-ph/pineapple-cluster.git
        ```
    * Set the required environment variables:
        ```sh
        # Your Proxmox API URL. For example: https://PROXMOX_IP_ADDRESS:8006/api2/json
        export TF_VAR_pm_api_url=YOUR_PROXMOX_API_URL
        
        # Your Proxmox API Token ID and Secret.
        export TF_VAR_pm_api_token_id=YOUR_PROXMOX_API_TOKEN_ID
        export TF_VAR_pm_api_token_secret=YOUR_PROXMOX_API_TOKEN_SECRET
        
        # Specify whether you want to disable the TLS verification while connecting to your Proxmox API server. In testing environment, `true` is just fine.
        export TF_VAR_pm_tls_insecure=true
        
        # Your Proxmox host where the Guest VM will be placed
        export TF_VAR_pm_host=YOUR_PROXMOX_HOST
        
        # Your Proxmox storage ID where the Guest VM disks will be allocated
        export TF_VAR_vm_disk_storage=YOUR_PROXMOX_STORAGE_ID
        ```

### Usage
On your local machine, create your Kubernetes cluster with a single command:
```sh
make cluster
```

If `GNU make` is not available, you will need to run the following commands respectively to accomplish the same goal:
```sh
terraform init
terraform fmt -check
terraform validate
terraform apply --auto-approve
```

### Customization

By updating the Terraform variables, you can modify the cluster settings on demand:
```sh
export TF_VAR_control_plane_node_count=NUMBER_OF_CONTROL_PLANE_NODE
export TF_VAR_worker_node_count=NUMBER_OF_WORKER_NODE
```

Then, try a dry-run to see the differences:
```sh
make plan
```

Once you are confident with the plan, it is time to update the infrastructure:
```sh
make cluster
```