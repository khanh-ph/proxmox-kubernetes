output "vms" {
  value = {
    for host in proxmox_vm_qemu.vm : host.name => host.ssh_host
  }
}