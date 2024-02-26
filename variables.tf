# Environment
########################################################################
variable "env_name" {
  type        = string
  description = "The stage of the development lifecycle for the k8s cluster. Example: `prod`, `dev`, `qa`, `stage`, `test`"
  default     = "test"
}

variable "location" {
  type        = string
  description = "The city or region where the cluster is provisioned"
  default     = null
}

variable "cluster_number" {
  type        = string
  description = "The instance count for the k8s cluster, to differentiate it from other clusters. Example: `00`, `01`"
  default     = "01"
}

variable "cluster_domain" {
  type        = string
  description = "The cluster domain name"
  default     = "local"
}

locals {
  cluster_name = var.location != null ? "k8s-${var.env_name}-${var.location}-${var.cluster_number}" : "k8s-${var.env_name}-${var.cluster_number}"
  cluster_fqdn = "${local.cluster_name}.${var.cluster_domain}"
}

variable "use_legacy_naming_convention" {
  type        = bool
  description = "Whether to use legacy naming convention for the VM and cluster name. If your cluster was provisioned using version <= 3.x, set it to `true`"
  default     = false
}

# Proxmox VE
########################################################################
variable "pm_api_url" {
  type        = string
  description = "The base URL for Proxmox VE API. See https://pve.proxmox.com/wiki/Proxmox_VE_API#API_URL"
}
variable "pm_api_token_id" {
  type        = string
  description = "The token ID to access Proxmox VE API."
}
variable "pm_api_token_secret" {
  type        = string
  description = "The UUID/secret of the token defined in the variable `pm_api_token_id`."
  sensitive   = true
}
variable "pm_tls_insecure" {
  type        = bool
  description = "Disable TLS verification while connecting to the Proxmox VE API server."
}
variable "pm_host" {
  type        = string
  description = "The name of Proxmox node where the VM is placed."
}

variable "pm_parallel" {
  type        = number
  description = "The number of simultaneous Proxmox processes. E.g: creating resources."
  default     = 2
}

variable "pm_timeout" {
  type        = number
  description = "Timeout value (seconds) for proxmox API calls."
  default     = 600
}

# Common infrastructure
########################################################################
variable "internal_net_name" {
  type        = string
  description = "Name of the internal network bridge"
  default     = "vmbr1"
}

variable "internal_net_subnet_cidr" {
  type        = string
  description = "CIDR of the internal network"
  default     = "10.0.1.0/24"
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key in base64, will be used by Terraform client to connect to the VM after provisioning"
}

variable "ssh_public_keys" {
  type        = string
  description = "SSH public keys in base64"
}

variable "vm_user" {
  type        = string
  description = "The default user for all VMs"
  default     = "ubuntu"
}

variable "vm_sockets" {
  type        = number
  description = "Number of the CPU socket to allocate to the VMs"
  default     = 1
}

variable "vm_max_vcpus" {
  type        = number
  description = "The maximum CPU cores available per CPU socket to allocate to the VM"
  default     = 2
}

variable "vm_cpu_type" {
  type        = string
  description = "The type of CPU to emulate in the Guest"
  default     = "host"
}

variable "vm_os_disk_storage" {
  type        = string
  description = "Default storage pool where OS VM disk is placed"
}

variable "add_worker_node_data_disk" {
  type        = bool
  description = "Whether to add a data disk to each worker node of the cluster"
  default     = false
}

variable "worker_node_data_disk_storage" {
  type        = string
  description = "The storage pool where the data disk is placed"
  default     = ""
}

variable "worker_node_data_disk_size" {
  type        = string
  description = "The size of worker node data disk in Gigabyte"
  default     = 10
}

variable "vm_ubuntu_tmpl_name" {
  type        = string
  description = "Name of Cloud-init template Ubuntu VM"
  default     = "ubuntu-2204"
}

variable "bastion_ssh_ip" {
  type        = string
  description = "IP of the bastion host, could be either public IP or local network IP of the bastion host"
  default     = ""
}

variable "bastion_ssh_user" {
  type        = string
  description = "The user to authenticate to the bastion host"
  default     = "ubuntu"
}

variable "bastion_ssh_port" {
  type        = number
  description = "The SSH port number on the bastion host"
  default     = 22
}

# Kuberentes VM specifications for Kubernetes nodes
########################################################################
variable "vm_k8s_control_plane" {
  type        = object({ node_count = number, vcpus = number, memory = number, disk_size = number })
  description = "Control Plane VM specification"
  default     = { node_count = 1, vcpus = 2, memory = 1536, disk_size = 20 }
}

variable "vm_k8s_worker" {
  type        = object({ node_count = number, vcpus = number, memory = number, disk_size = number })
  description = "Worker VM specification"
  default     = { node_count = 2, vcpus = 2, memory = 2048, disk_size = 20 }
}

# Kubernetes settings
########################################################################
variable "create_kubespray_host" {
  type        = bool
  description = "Whether to provision the Kubespray as a VM"
  default     = true
}

variable "kubespray_image" {
  type        = string
  description = "The Docker image to deploy Kubespray"
  default     = "quay.io/kubespray/kubespray:v2.23.1"
}

variable "kube_version" {
  type        = string
  description = "Kubernetes version"
  default     = "v1.27.7"
}
variable "kube_network_plugin" {
  type        = string
  description = "The network plugin to be installed on your cluster. Example: `cilium`, `calico`, `kube-ovn`, `weave` or `flannel`"
  default     = "calico"
}

variable "enable_nodelocaldns" {
  type        = bool
  description = "Whether to enable nodelocal dns cache on your cluster"
  default     = false
}
variable "podsecuritypolicy_enabled" {
  type        = bool
  description = "Whether to enable pod security policy on your cluster (RBAC must be enabled either by having 'RBAC' in authorization_modes or kubeadm enabled)"
  default     = false
}
variable "persistent_volumes_enabled" {
  type        = bool
  description = "Whether to add Persistent Volumes Storage Class for corresponding cloud provider (supported: in-tree OpenStack, Cinder CSI, AWS EBS CSI, Azure Disk CSI, GCP Persistent Disk CSI)"
  default     = false
}
variable "helm_enabled" {
  type        = bool
  description = "Whether to enable Helm on your cluster"
  default     = false
}
variable "ingress_nginx_enabled" {
  type        = bool
  description = "Whether to enable Nginx ingress on your cluster"
  default     = false
}
variable "argocd_enabled" {
  type        = bool
  description = "Whether to enable ArgoCD on your cluster"
  default     = false
}
variable "argocd_version" {
  type        = string
  description = "The ArgoCD version to be installed"
  default     = "v2.9.3"
}


