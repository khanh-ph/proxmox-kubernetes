#
# Proxmox VE
#
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

#
# Environment
#

variable "env_name" {
  type    = string
  default = "test"
}

#
# Common infrastructure
#

variable "internal_net_name" {
  type        = string
  description = "Name of the internal network bridge."
  default     = "vmbr1"
}

variable "internal_net_subnet_cidr" {
  type        = string
  description = "CIDR of the internal network. For example: 10.0.1.0/24"
  default     = ""
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key in base64. Used by Terraform client to connect to the VM after provisioning."
}

variable "ssh_public_keys" {
  type        = string
  description = "SSH public keys in base64."
}

variable "vm_user" {
  type    = string
  default = "ubuntu"
}

variable "vm_sockets" {
  type    = number
  default = 1
}

variable "vm_max_vcpus" {
  type        = number
  description = "The maximum CPU cores available per CPU socket to allocate to the VM."
  default     = 2
}

variable "vm_cpu_type" {
  type        = string
  description = "The type of CPU to emulate in the Guest"
  default     = "host"
}

variable "vm_os_disk_storage" {
  type        = string
  description = "Default storage pool where OS VM disk is placed."
}

variable "add_worker_node_data_disk" {
  type        = bool
  description = "A boolean value that indicates whether to add a data disk to each worker node of the cluster."
  default     = false
}

variable "worker_node_data_disk_storage" {
  type        = string
  description = "The storage pool where the data disk is placed."
  default     = ""
}

variable "worker_node_data_disk_size" {
  type        = string
  description = "The size of worker node data disk in Gigabyte."
  default     = 10
}

variable "vm_ubuntu_tmpl_name" {
  type        = string
  description = "Name of Cloud-init template Ubuntu VM."
  default     = "ubuntu-2204"
}

#
# Bastion host
#

variable "bastion_ssh_ip" {
  type        = string
  description = "IP of the bastion host. It could be either public IP or local network IP of the bastion host."
  default     = ""
}

variable "bastion_ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "bastion_ssh_port" {
  type    = number
  default = 22
}

#
# Kubesray options
#

variable "create_kubespray_host" {
  type    = bool
  default = true
}

variable "kubespray_image" {
  type    = string
  default = "khanhphhub/kubespray:v2.22.0"
}

variable "kube_version" {
  type        = string
  description = "Kubernetes version"
  default     = "v1.24.6"
}
variable "kube_network_plugin" {
  type        = string
  description = "Choose network plugin (cilium, calico, kube-ovn, weave or flannel. Use cni for generic cni plugin)"
  default     = "calico"
}
variable "enable_nodelocaldns" {
  type        = bool
  description = "Enable nodelocal dns cache"
  default     = false
}
variable "podsecuritypolicy_enabled" {
  type        = bool
  description = "pod security policy (RBAC must be enabled either by having 'RBAC' in authorization_modes or kubeadm enabled)"
  default     = false
}
variable "persistent_volumes_enabled" {
  type        = bool
  description = "Add Persistent Volumes Storage Class for corresponding cloud provider (supported: in-tree OpenStack, Cinder CSI, AWS EBS CSI, Azure Disk CSI, GCP Persistent Disk CSI)"
  default     = false
}
variable "helm_enabled" {
  type        = bool
  description = "Helm deployment"
  default     = false
}
variable "ingress_nginx_enabled" {
  type        = bool
  description = "Nginx ingress controller deployment"
  default     = false
}
variable "argocd_enabled" {
  type        = bool
  description = "ArgoCD"
  default     = false
}
variable "argocd_version" {
  type        = string
  description = "ArgoCD version"
  default     = "v2.4.12"
}

#
# VM specifications for Kubernetes nodes
#
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