## About the project

This project allows you to create a Kubernetes cluster on [Proxmox VE](https://pve.proxmox.com/wiki/Main_Page) using [Terraform](https://www.terraform.io/) and [Kubespray](https://github.com/kubernetes-sigs/kubespray) in a declarative manner.

![Proxmox Kubernetes clusters](proxmox-kubernetes.png)

## Prerequisites

### Software requirements

Ensure the following software versions are installed:

* [Proxmox VE](https://www.proxmox.com/en/proxmox-ve/get-started/) `>=7.3.3`
* [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli/) `>=1.3.3`

> Kubespray has been set up automatically.

### System requirements

Before proceeding with the setup for Proxmox VE, make sure you have the following components in place:

* Internal network
* VM template
* SSH key pair
* Bastion host

### Usage

Follow these steps to use the project:

1. Clone the repo:

    ```sh
    $ git clone https://github.com/khanh-ph/proxmox-kubernetes.git
    ```

2. Open the `example.tfvars` file in a text editor and update all the mandatory variables with your own values.

3. Initialize the Terraform working directory.

    ```sh
    $ terraform init
    ```

4. Generate execution plan and review the output to ensure that the planned changes align with your expectations.

    ```sh
    $ terraform plan -var-file="example.tfvars"
    ```

5. If you're satisfy with the plan and ready to apply the changes. Run the following command:

    ```sh
    $ terraform apply -var-file="example.tfvars"
    ```

## Configurations

The project provides several Terraform variables that allow you to customize the cluster to suit your needs. Please see the following:

### Mandatory variables

Below are the mandatory variables:

* `env_name`
* `pm_api_url`
* `pm_api_token_id`
* `pm_api_token_secret`
* `pm_tls_insecure`
* `pm_host`
* `internal_net_name`
* `internal_net_subnet_cidr`
* `bastion_ssh_port`
* `bastion_ssh_ip`
* `bastion_ssh_user`
* `ssh_public_keys`
* `ssh_private_key`
* `vm_max_vcpus`
* `vm_k8s_control_plane`
* `vm_k8s_worker`

### Kubespray variables (optional)

You may also configure the following optional variables specific to Kubespray:

* `kube_version`
* `kube_network_plugin`
* `enable_nodelocaldns`
* `podsecuritypolicy_enabled`
* `persistent_volumes_enabled`
* `helm_enabled`
* `ingress_nginx_enabled`
* `argocd_enabled`
* `argocd_version`

## Blog posts

For more detailed instructions, refer to the following blog post: [Create a Kubernetes cluster on Proxmox with Terraform & Kubespray](https://www.khanhph.com/install-proxmox-kubernetes/)
