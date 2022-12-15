module "promox_kubernetes_worker" {
  source = "../proxmox_ubuntu_vm"

  pm_host             = var.pm_host
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure

  prefix = "${var.name}-worker"

  vm_count             = var.worker.vm_count
  vm_disk_storage      = var.worker.vm_disk_storage
  vm_memory_mb         = var.worker.vm_memory_mb
  vm_cpus              = var.worker.vm_cpus
  vm_os_disk_size_gb   = var.worker.vm_os_disk_size_gb
  vm_authorized_keys   = var.worker.vm_authorized_keys
  vm_net_use_dhcp      = var.worker.vm_net_use_dhcp
  vm_net_bridge        = var.worker.vm_net_bridge
  vm_net_cidr          = var.worker.vm_net_cidr
  vm_net_hostnum_start = 20
}

module "promox_kubernetes_control_plane" {
  source = "../proxmox_ubuntu_vm"

  pm_host             = var.pm_host
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure

  prefix = "${var.name}-control-plane"

  vm_count             = var.control_plane.vm_count
  vm_disk_storage      = var.control_plane.vm_disk_storage
  vm_memory_mb         = var.control_plane.vm_memory_mb
  vm_cpus              = var.control_plane.vm_cpus
  vm_os_disk_size_gb   = var.control_plane.vm_os_disk_size_gb
  vm_authorized_keys   = var.control_plane.vm_authorized_keys
  vm_net_use_dhcp      = var.control_plane.vm_net_use_dhcp
  vm_net_bridge        = var.control_plane.vm_net_bridge
  vm_net_cidr          = var.control_plane.vm_net_cidr
  vm_net_hostnum_start = 10
}