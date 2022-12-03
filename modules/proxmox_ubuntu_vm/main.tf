terraform {
  required_version = ">=1.3.3"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure
}

resource "proxmox_vm_qemu" "vm" {
  count       = var.vm_count
  target_node = var.pm_host
  clone       = var.template_name
  name        = "${var.prefix}-${format("%04d", count.index)}"
  agent       = 1
  onboot      = var.vm_onboot
  os_type     = "cloud-init"
  cores       = var.vm_cpus
  sockets     = var.vm_socket
  cpu         = var.vm_cpu_type
  memory      = var.vm_memory_mb
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disk {
    slot    = 0
    type    = "scsi"
    storage = try(var.vm_disk_storage, "local-zfs")
    size    = try("${var.vm_os_disk_size_gb}G", "10G")
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = var.vm_ifconfig0

  ciuser  = var.vm_user
  sshkeys = <<EOF
  ${var.vm_authorized_keys}
  EOF

  # lifecycle {
  #   ignore_changes = [
  #     ciuser,
  #     sshkeys,
  #     disk.
  #     network
  #   ]
  # }
}
