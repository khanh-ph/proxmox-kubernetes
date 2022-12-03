output "workers" {
  value = module.promox_kubernetes_worker.vms
}

output "control_planes" {
  value = module.promox_kubernetes_control_plane.vms
}