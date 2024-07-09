module "k8s_control_plane_nodes" {
  source = "./modules/proxmox_ubuntu_vm"

  node_count                   = var.vm_k8s_control_plane["node_count"]
  pm_host                      = var.pm_host
  vm_ubuntu_tmpl_name          = var.vm_ubuntu_tmpl_name
  vm_name_prefix               = var.use_legacy_naming_convention ? "${var.env_name}-k8s-cplane" : "vm-${local.cluster_name}-cp"
  vm_max_vcpus                 = var.vm_max_vcpus
  vm_vcpus                     = var.vm_k8s_control_plane["vcpus"]
  vm_sockets                   = var.vm_sockets
  vm_cpu_type                  = var.vm_cpu_type
  vm_memory_mb                 = var.vm_k8s_control_plane["memory"]
  vm_os_disk_storage           = var.vm_os_disk_storage
  vm_os_disk_size_gb           = var.vm_k8s_control_plane["disk_size"]
  vm_net_name                  = var.internal_net_name
  vm_net_subnet_cidr           = var.internal_net_subnet_cidr
  vm_host_number               = 10
  vm_user                      = var.vm_user
  vm_tags                      = "${var.env_name};terraform;k8s_control_plane"
  ssh_public_keys              = var.ssh_public_keys
  use_legacy_naming_convention = var.use_legacy_naming_convention
}

module "k8s_worker_nodes" {
  source = "./modules/proxmox_ubuntu_vm"

  node_count                    = var.vm_k8s_worker["node_count"]
  pm_host                       = var.pm_host
  vm_ubuntu_tmpl_name           = var.vm_ubuntu_tmpl_name
  vm_name_prefix                = var.use_legacy_naming_convention ? "${var.env_name}-k8s-worker" : "vm-${local.cluster_name}-worker"
  vm_max_vcpus                  = var.vm_max_vcpus
  vm_vcpus                      = var.vm_k8s_worker["vcpus"]
  vm_sockets                    = var.vm_sockets
  vm_cpu_type                   = var.vm_cpu_type
  vm_memory_mb                  = var.vm_k8s_worker["memory"]
  vm_os_disk_storage            = var.vm_os_disk_storage
  vm_os_disk_size_gb            = var.vm_k8s_worker["disk_size"]
  vm_net_name                   = var.internal_net_name
  vm_net_subnet_cidr            = var.internal_net_subnet_cidr
  vm_host_number                = 20
  vm_user                       = var.vm_user
  vm_tags                       = "${var.env_name};terraform;k8s_worker"
  ssh_public_keys               = var.ssh_public_keys
  add_worker_node_data_disk     = var.add_worker_node_data_disk
  worker_node_data_disk_storage = var.worker_node_data_disk_storage
  worker_node_data_disk_size    = var.worker_node_data_disk_size
  use_legacy_naming_convention  = var.use_legacy_naming_convention
}

output "k8s_control_plane" {
  value = module.k8s_control_plane_nodes.vm_list
}

output "k8s_worker" {
  value = module.k8s_worker_nodes.vm_list
}