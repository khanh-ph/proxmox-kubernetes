resource "local_file" "inventory" {
  content = templatefile(
    "kubespray/inventory.tftpl",
    {
      control_plane_ips = "${join("\n", [for hostname, ip in module.infrastructure.control_planes : join("", [hostname, " ansible_ssh_host=${ip}", " ansible_connection=ssh"])])}"
      worker_ips        = "${join("\n", [for hostname, ip in module.infrastructure.workers : join("", [hostname, " ansible_ssh_host=${ip}", " ansible_connection=ssh"])])}"
      bastion           = var.bastion_host_ssh_ip != "" ? "[bastion]\nbastion ansible_host=${var.bastion_host_ssh_ip} ansible_port=${var.bastion_host_ssh_port} ansible_user=${var.bastion_host_ssh_user}" : ""
    }
  )
  filename = "${var.ks_tmp}/inventory.ini"

  depends_on = [
    module.infrastructure
  ]
}

resource "local_file" "k8s-cluster" {
  content = templatefile(
    "kubespray/k8s-cluster.tftpl",
    {
      kube_version               = var.kube_version
      kube_network_plugin        = var.kube_network_plugin
      enable_nodelocaldns        = var.enable_nodelocaldns
      podsecuritypolicy_enabled  = var.podsecuritypolicy_enabled
      persistent_volumes_enabled = var.persistent_volumes_enabled
    }
  )
  filename = "${var.ks_tmp}/k8s-cluster.yml"

  depends_on = [
    module.infrastructure
  ]
}

resource "local_file" "addons" {
  content = templatefile(
    "kubespray/addons.tftpl",
    {
      helm_enabled          = var.helm_enabled
      ingress_nginx_enabled = var.ingress_nginx_enabled
      argocd_enabled        = var.argocd_enabled
      argocd_version        = var.argocd_version
    }
  )
  filename = "${var.ks_tmp}/addons.yml"

  depends_on = [
    module.infrastructure
  ]
}

resource "local_file" "ansible_private_key" {
  content = templatefile(
    "kubespray/ansible-pvkey.tftpl",
    {
      key = base64decode(var.base64_ansible_private_key)
    }
  )
  filename = "${var.ks_tmp}/id_rsa"

  depends_on = [
    module.infrastructure
  ]
}