module "k8s" {
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
    vm_os_disk_size_gb = 10
    vm_memory_mb       = 1024
    vm_cpus            = 2
    vm_authorized_keys = var.vm_authorized_keys
  }

  worker = {
    vm_count           = var.worker_node_count
    vm_disk_storage    = var.vm_disk_storage
    vm_os_disk_size_gb = 15
    vm_memory_mb       = 2048
    vm_cpus            = 2
    vm_authorized_keys = var.vm_authorized_keys
  }
}
