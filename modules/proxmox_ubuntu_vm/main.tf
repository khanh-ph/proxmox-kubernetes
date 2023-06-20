terraform {
  required_version = ">=1.3.3"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

resource "proxmox_vm_qemu" "ubuntu_vm" {
  count            = var.node_count
  target_node      = var.pm_host
  clone            = var.vm_ubuntu_tmpl_name
  qemu_os          = "l26"
  name             = "${var.vm_name_prefix}-${format("%02d", count.index)}"
  agent            = 1
  onboot           = var.vm_onboot
  os_type          = "cloud-init"
  cores            = var.vm_max_vcpus
  vcpus            = var.vm_vcpus
  sockets          = var.vm_sockets
  cpu              = var.vm_cpu_type
  memory           = var.vm_memory_mb
  bootdisk         = "virtio0"
  scsihw           = "virtio-scsi-single"
  hotplug          = "network,disk,usb,memory,cpu"
  numa             = true
  automatic_reboot = false
  desc             = "This VM is managed by Terraform, cloned from an Cloud-init Ubuntu image, configured with an internal network and supports CPU hotplug/hot unplug and memory hotplug capabilities."
  tags             = var.vm_tags

  disk {
    slot     = 0
    type     = "virtio"
    storage  = var.vm_os_disk_storage
    size     = "${var.vm_os_disk_size_gb}G"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = var.vm_net_name
  }

  ipconfig0 = "ip=${cidrhost(var.vm_net_subnet_cidr, var.vm_host_number + count.index)}${local.vm_net_subnet_mask},gw=${local.vm_net_default_gw}"

  ciuser  = var.vm_user
  sshkeys = base64decode(var.ssh_public_keys)

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}