locals {
  kubespray_data_dir = "$HOME/kubespray_data"

  setup_kubespray_script_content = templatefile(
    "${path.module}/scripts/setup_kubespray.sh",
    {
      kubespray_data_dir = local.kubespray_data_dir
    }
  )

  install_kubernetes_script_content = templatefile(
    "${path.module}/scripts/install_kubernetes.sh",
    {
      kubespray_data_dir = local.kubespray_data_dir,
      kubespray_image    = var.kubespray_image
    }
  )

  kubespray_inventory_content = templatefile(
    "${path.module}/kubespray/inventory.ini",
    {
      cp_nodes     = join("\n", [for host in module.k8s_control_plane_nodes.vm_list : join("", [host.name, " ansible_ssh_host=${host.ip0}", " ansible_connection=ssh"])])
      worker_nodes = join("\n", [for host in module.k8s_worker_nodes.vm_list : join("", [host.name, " ansible_ssh_host=${host.ip0}", " ansible_connection=ssh"])])
      bastion      = "" # var.bastion_ssh_ip != "" ? "[bastion]\nbastion ansible_host=${var.bastion_ssh_ip} ansible_port=${var.bastion_ssh_port} ansible_user=${var.bastion_ssh_user}" : ""
    }
  )

  kubespray_k8s_config_content = templatefile(
    "${path.module}/kubespray/k8s-cluster.yaml",
    {
      kube_version                        = var.kube_version
      kube_network_plugin                 = var.kube_network_plugin
      cluster_name                        = local.cluster_fqdn
      enable_nodelocaldns                 = var.enable_nodelocaldns
      podsecuritypolicy_enabled           = var.podsecuritypolicy_enabled
      persistent_volumes_enabled          = var.persistent_volumes_enabled
      apiserver_loadbalancer_domain_name = var.apiserver_loadbalancer_domain_name
    }
  )

  kubespray_addon_config_content = templatefile(
    "${path.module}/kubespray/addons.yaml",
    {
      helm_enabled          = var.helm_enabled
      ingress_nginx_enabled = var.ingress_nginx_enabled
      argocd_enabled        = var.argocd_enabled
      argocd_version        = var.argocd_version
    }
  )

}


module "kubespray_host" {
  source = "./modules/proxmox_ubuntu_vm"

  node_count                   = var.create_kubespray_host ? 1 : 0
  pm_host                      = var.pm_host
  vm_ubuntu_tmpl_name          = var.vm_ubuntu_tmpl_name
  vm_name_prefix               = var.use_legacy_naming_convention ? "${var.env_name}-kubespray" : "vm-${local.cluster_name}-kubespray"
  vm_max_vcpus                 = var.vm_max_vcpus
  vm_vcpus                     = 2
  vm_sockets                   = var.vm_sockets
  vm_cpu_type                  = var.vm_cpu_type
  vm_memory_mb                 = 2048
  vm_os_disk_storage           = var.vm_os_disk_storage
  vm_os_disk_size_gb           = 10
  vm_net_name                  = var.internal_net_name
  vm_net_subnet_cidr           = var.internal_net_subnet_cidr
  vm_host_number               = 5
  vm_user                      = var.vm_user
  vm_tags                      = "${var.env_name};terraform;kubespray"
  ssh_public_keys              = var.ssh_public_keys
  use_legacy_naming_convention = var.use_legacy_naming_convention
  pm_between_actions_delay     = var.pm_between_actions_delay
}

resource "null_resource" "setup_kubespray" {

  count = var.create_kubespray_host ? 1 : 0

  provisioner "remote-exec" {
    inline = [
      local.setup_kubespray_script_content,
      "echo \"${var.ssh_private_key}\" | base64 -d > ${local.kubespray_data_dir}/id_rsa",
      <<-EOT
      cat <<EOF > ${local.kubespray_data_dir}/inventory.ini
      ${local.kubespray_inventory_content}
      EOF
      EOT
      ,
      <<-EOT
      cat <<EOF > ${local.kubespray_data_dir}/k8s-cluster.yml
      ${local.kubespray_k8s_config_content}
      EOF
      EOT
      ,
      <<-EOT
      cat <<EOF > ${local.kubespray_data_dir}/addons.yml
      ${local.kubespray_addon_config_content}
      EOF
      EOT
      ,
      "chmod 600 ${local.kubespray_data_dir}/*",
      local.install_kubernetes_script_content
    ]
  }

  connection {
    type         = "ssh"
    user         = var.vm_user
    private_key  = base64decode(var.ssh_private_key)
    host         = module.kubespray_host.vm_list[0].ip0
    port         = 22
    bastion_host = var.bastion_ssh_ip
    bastion_user = var.bastion_ssh_user
    bastion_port = var.bastion_ssh_port
    bastion_private_key = base64decode(var.bastion_private_key)
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    module.kubespray_host,
    module.k8s_control_plane_nodes,
    module.k8s_worker_nodes
  ]

}

output "kubespray_host" {
  value = module.kubespray_host.vm_list
}
