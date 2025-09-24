terraform {
  required_version = ">=1.3.3"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

resource "proxmox_vm_qemu" "ubuntu_vm" {
  count            = var.node_count
  target_node      = var.pm_hosts[count.index % length(var.pm_hosts)]
  clone            = var.vm_ubuntu_tmpl_name
  qemu_os          = "l26"
  name             = var.use_legacy_naming_convention ? "${var.vm_name_prefix}-${format("%02d", count.index)}" : "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
  agent            = 1
  onboot           = var.vm_onboot
  os_type          = "cloud-init"
  memory           = var.vm_memory_mb
  bootdisk         = "virtio0"
  scsihw           = "virtio-scsi-single"
  hotplug          = "network,disk,usb,memory,cpu"
  automatic_reboot = true
  description      = "This VM is managed by Terraform, cloned from an Cloud-init Ubuntu image, configured with an internal network and supports CPU hotplug/hot unplug and memory hotplug capabilities."
  tags             = var.vm_tags
  cpu {
    sockets = 1
    cores = var.vm_cpu_cores
    numa             = true
  }
  disks {
    virtio {
      virtio0 {
        disk {
          size     = "${var.vm_os_disk_size_gb}G"
          storage  = var.vm_os_disk_storage
          iothread = true
        }
      }

      dynamic "virtio1" {
        for_each = var.add_worker_node_data_disk ? [var.worker_node_data_disk_size] : []
        content {
          disk {
            size     = "${var.worker_node_data_disk_size}G"
            storage  = var.worker_node_data_disk_storage
            iothread = true
          }
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = var.vm_os_disk_storage
        }
      }
    }
  }

  network {
    id = 0
    model  = "virtio"
    bridge = var.vm_net_name
    mtu = var.vm_net_mtu
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
