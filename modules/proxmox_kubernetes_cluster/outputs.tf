output "worker_ips" {
  value = module.promox_kubernetes_worker.vm_ips
}

output "control_plane_ips" {
  value = module.promox_kubernetes_control_plane.vm_ips
}