module "k8s" {
  source = "./modules/proxmox_kubernetes_cluster"
  name   = "hello-k8s"

  pm_host             = var.pm_host
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure

  control_plane = {
    vm_count           = var.control_plane_node_count
    vm_disk_storage    = var.vm_disk_storage
    vm_os_disk_size_gb = 10
    vm_memory_mb       = 1024
    vm_cpus            = 1
    vm_authorized_keys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAzwZMnc1PrchVLgp4uxrd+uLdpOWimMYDRaumHfhvxwyxqYlVJCW4NiOImEdGhQ7TaDnb7sq5pITyW4WZjBvC7ZCdP+KH2pNgP6PKhQEHxaaQWbsJeZSkR2l/vIS2XGpw8sEeDn0I7zwqOK3aJNF0ZLfX8Nn1cnGCD+keds1B0o34yGDizlHlP4rr1YyEj+eThZF71maigXongdicdtgMF4f2Z4mXObTQCs8eux83YYL4k4gpjcNzbM9Fr2oUPNMqc/xXG0FCqsM7GXXhT7o+eLM6ZDx/lY6LQiHnHocRIfawtWZhOLZ2RDEr2TUJzyGl3qPCOyIc9m3lReV9WmOE644oT0QqYiX6hUpLNOEGq7d/jiLIgL9E3TTzqUYFnQWVUrbOefNmX2My+lMSrdYEZ4wJsTmPOoeaFPvKUqHPZgGXW2hLKfbf2+RIOi4laQ9FDI1paV/eRvGYNsVkpSo/Xt4fqO2P3xF237k5frQtrLE0lUEVlzVcLaQvnNxrzNgby4E0n1ACxfRlqtQgaeToiwepT2gIiely/DLHb4QuTPWweRas4Y5eMsSM6ADtqd15EyFQqI/rjPTPF9LQDPKfrzKjPlKZQAJBv/ph87jgZkBEERlayFs4CnWnVeLOc0wG7udvwPxFqUNt5kQVEutBWcX8gXyymGYSmHpgavgoFes= khph@dpcm
    EOF
  }

  worker = {
    vm_count           = var.worker_node_count
    vm_disk_storage    = var.vm_disk_storage
    vm_os_disk_size_gb = 15
    vm_memory_mb       = 2048
    vm_cpus            = 2
    vm_authorized_keys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAzwZMnc1PrchVLgp4uxrd+uLdpOWimMYDRaumHfhvxwyxqYlVJCW4NiOImEdGhQ7TaDnb7sq5pITyW4WZjBvC7ZCdP+KH2pNgP6PKhQEHxaaQWbsJeZSkR2l/vIS2XGpw8sEeDn0I7zwqOK3aJNF0ZLfX8Nn1cnGCD+keds1B0o34yGDizlHlP4rr1YyEj+eThZF71maigXongdicdtgMF4f2Z4mXObTQCs8eux83YYL4k4gpjcNzbM9Fr2oUPNMqc/xXG0FCqsM7GXXhT7o+eLM6ZDx/lY6LQiHnHocRIfawtWZhOLZ2RDEr2TUJzyGl3qPCOyIc9m3lReV9WmOE644oT0QqYiX6hUpLNOEGq7d/jiLIgL9E3TTzqUYFnQWVUrbOefNmX2My+lMSrdYEZ4wJsTmPOoeaFPvKUqHPZgGXW2hLKfbf2+RIOi4laQ9FDI1paV/eRvGYNsVkpSo/Xt4fqO2P3xF237k5frQtrLE0lUEVlzVcLaQvnNxrzNgby4E0n1ACxfRlqtQgaeToiwepT2gIiely/DLHb4QuTPWweRas4Y5eMsSM6ADtqd15EyFQqI/rjPTPF9LQDPKfrzKjPlKZQAJBv/ph87jgZkBEERlayFs4CnWnVeLOc0wG7udvwPxFqUNt5kQVEutBWcX8gXyymGYSmHpgavgoFes= khph@dpcm
    EOF
  }
}
