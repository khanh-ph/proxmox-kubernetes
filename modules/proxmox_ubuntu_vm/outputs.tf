output "vm_ips" {
  value = proxmox_vm_qemu.vm[*].ssh_host
}