output "worker_ips" {
  value = module.k8s.worker_ips
}

output "control_plane_ips" {
  value = module.k8s.control_plane_ips
}