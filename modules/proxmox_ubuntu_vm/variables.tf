variable "pm_host" {
  type        = string
  description = "The name of Proxmox node where the VM is placed."
}

variable "vm_name_prefix" {
  type        = string
  description = "VM prefix name"
  default     = "vm"
}

variable "node_count" {
  type        = number
  description = ""
}

variable "vm_tags" {
  type    = string
  default = ""
}

variable "vm_net_name" {
  type        = string
  description = ""
}

variable "vm_net_subnet_cidr" {
  type        = string
  description = "Address prefix for the internal network"
}

variable "ssh_public_keys" {
  type        = string
  description = "SSH public keys in base64."
}

variable "vm_onboot" {
  type        = bool
  description = "Start the VM right after Proxmox host starts"
  default     = true
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

variable "vm_vcpus" {
  type        = number
  description = "The number of CPU cores to allocate to the VM. This should be less or equal to vm_max_vcpus."
  default     = 2
}

variable "vm_cpu_type" {
  type        = string
  description = "The type of CPU to emulate in the Guest"
  default     = "host"
}

variable "vm_memory_mb" {
  type        = number
  description = "The size of VM memory in MB"
  default     = 2048
}

variable "vm_os_disk_size_gb" {
  type        = number
  description = "The size of VM OS disk in Gigabyte"
  default     = 20
}

variable "vm_os_disk_storage" {
  type        = string
  description = "Default storage pool where OS VM disk is placed."
}

variable "vm_ubuntu_tmpl_name" {
  type        = string
  description = "Name of Cloud-init template Ubuntu VM."
  default     = "ubuntu-2404"
}

variable "vm_host_number" {
  type        = number
  description = "The host number of the VM in the subnet"
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

variable "use_legacy_naming_convention" {
  type    = bool
  default = false
}

#
# Local vars
# 
locals {
  vm_net_subnet_mask = "/${split("/", var.vm_net_subnet_cidr)[1]}"
  vm_net_default_gw  = cidrhost(var.vm_net_subnet_cidr, 1)
}
