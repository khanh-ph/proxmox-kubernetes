module "infrastructure" {
  source = "./modules/proxmox_kubernetes_cluster"

  pm_host             = var.pm_host
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure

  name = var.cluster_name

  control_plane = {
    vm_count           = var.control_plane_node_count
    vm_disk_storage    = var.vm_disk_storage
    vm_os_disk_size_gb = var.vm_os_disk_size_gb
    vm_memory_mb       = var.vm_memory_mb
    vm_cpus            = var.vm_cpus
    vm_authorized_keys = base64decode(var.base64_vm_authorized_keys)
    vm_net_use_dhcp    = var.vm_net_use_dhcp
    vm_net_bridge      = var.vm_net_bridge
    vm_net_cidr        = var.vm_net_cidr
  }

  worker = {
    vm_count           = var.worker_node_count
    vm_disk_storage    = var.vm_disk_storage
    vm_os_disk_size_gb = var.vm_os_disk_size_gb
    vm_memory_mb       = var.vm_memory_mb
    vm_cpus            = var.vm_cpus
    vm_authorized_keys = base64decode(var.base64_vm_authorized_keys)
    vm_net_use_dhcp    = var.vm_net_use_dhcp
    vm_net_bridge      = var.vm_net_bridge
    vm_net_cidr        = var.vm_net_cidr
  }
}

