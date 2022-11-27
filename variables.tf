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
}
variable "pm_tls_insecure" {
  type        = bool
  description = "Disable TLS verification while connecting to the Proxmox VE API server."
}
variable "pm_host" {
  type        = string
  description = "The name of Proxmox node where the VM is placed."
}
variable "vm_disk_storage" {
  type        = string
  description = "The ID of the storage pool on Proxmox VE where the VM disks are located"
}
variable "control_plane_node_count" {
  type        = number
  description = "The number of Kubernetes Control Plane node"
  default     = 1
}
variable "worker_node_count" {
  type        = number
  description = "The number of Kubernetes Worker node"
  default     = 2
}
variable "cluster_name" {
  type        = string
  description = "The name of cluster"
  default     = "example-k8s"
}
variable "vm_authorized_keys" {
  type        = string
  description = "SSH public keys of the Bastion host"
  default     = ""
}