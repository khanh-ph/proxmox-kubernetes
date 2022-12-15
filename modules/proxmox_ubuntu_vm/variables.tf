variable "pm_api_url" {
  type        = string
  description = "URL of proxmox API server; e.g https://proxmox.yourdomain.com/api2/json"
}

variable "pm_api_token_id" {
  type        = string
  description = "Proxmox API token ID"
}

variable "pm_api_token_secret" {
  type        = string
  description = "Proxmox API token secret"
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Set to true to bypass TLS certificate verification of your Promox API server URL"
  default     = true
}

variable "pm_host" {
  type        = string
  description = "Name of the host server in Proxmox data center where the VM will be hosted"
}

variable "template_name" {
  type        = string
  description = "Name of cloud-init ubuntu template on Proxmox"
  default     = "ubuntu-2204"
}

variable "prefix" {
  type        = string
  description = "Prefix for the vm name"
}

variable "vm_user" {
  type        = string
  description = "Default admin username"
  default     = "ubuntu"
}

variable "vm_authorized_keys" {
  type        = string
  description = "SSH public key of the Jump host"
  default     = ""
}

variable "vm_count" {
  type        = number
  description = "Number of virtual machines to be created"
  default     = 1
}

variable "vm_disk_storage" {
  type        = string
  description = "Storage type; e.g: local-lvm or local-zfs"
  default     = "local-zfs"
}

variable "vm_os_disk_size_gb" {
  type        = number
  description = "Root disk size in GB; e.g: 10"
  default     = 10
}

variable "vm_cpus" {
  type        = number
  description = "No of CPU cores; e.g: 1"
  default     = 1
}

variable "vm_cpu_type" {
  type        = string
  description = "The type of CPU to emulate in the Guest"
  default     = "host"
}

variable "vm_memory_mb" {
  type        = number
  description = "VM memory in MB; e.g: 1024"
  default     = 1024
}

variable "vm_onboot" {
  type        = bool
  description = "Start the VM right after Proxmox host starts"
  default     = true
}

variable "vm_socket" {
  type        = number
  description = "The number of CPU sockets to allocate to the VM"
  default     = 1
}

variable "vm_net_dhcp_enabled" {
  type        = bool
  description = "use DHCP for all VMs IP"
  default     = true
}

variable "vm_net_bridge" {
  type        = string
  description = "Linux bridge name where the VM is attached to"
  default     = "vmbr0"
}

variable "vm_net_cidr" {
  type        = string
  description = "CIDR of vm_net_bridge"
  default     = ""
}

variable "vm_net_hostnum_start" {
  type        = string
  description = "hostnum to calculate VM IP from CIDR"
  default     = 2
}
