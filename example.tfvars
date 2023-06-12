# Environment
########################################################################
## Replace `demo` with your desired environment name.
env_name = "demo"


# Proxmox VE
########################################################################
## Specify Proxmox VE API URL, token details, and Proxmox host where VM will be hosted.
pm_api_url          = "https://your-proxmox-url/api"
pm_api_token_id     = "your-api-token-id"
pm_api_token_secret = "your-api-token-secret"
pm_tls_insecure     = false
pm_host             = "your-proxmox-host"


# Internal Network
########################################################################
## Replace `vmbr1` with your bridge name dedicated to the Kubernetes internal network.
internal_net_name = "vmbr1"
## Replace `10.0.1.0/24` with your internal network address and prefix length.
internal_net_subnet_cidr = "10.0.1.0/24"


# Bastion Host
########################################################################
## Replace `192.168.1.131` with LAN IP/ public IP address of your bastion host.
bastion_ssh_port = 22
bastion_ssh_ip   = "192.168.1.131"
bastion_ssh_user = "ubuntu"


# SSH
########################################################################
## Specify base64 encoding of SSH keys for Kubernetes admin authentication.
ssh_public_keys = "put-base64-encoded-public-keys-here"
ssh_private_key = "put-base64-encoded-private-key-here"


# VM specifications
########################################################################
# Replace `2` with the maximum cores that your Proxmox VE server can give to a VM.
vm_max_vcpus = 2
# Specify the VM specifications for the Kubernetes control plane.
vm_k8s_control_plane = "{ node_count = 1, vcpus = 2, memory = 2048, disk_size = 20 }"
# Specify the VM specifications for the Kubernetes worker nodes.
vm_k8s_worker = "{ node_count = 3, vcpus = 2, memory = 3072, disk_size = 20 }"
