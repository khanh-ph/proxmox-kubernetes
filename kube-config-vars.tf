variable "kube_version" {
  type        = string
  description = "Kubernetes version"
  default     = "v1.24.6"
}
variable "kube_network_plugin" {
  type        = string
  description = "Choose network plugin (cilium, calico, kube-ovn, weave or flannel. Use cni for generic cni plugin)"
  default     = "calico"
}
variable "enable_nodelocaldns" {
  type        = bool
  description = "Enable nodelocal dns cache"
  default     = false
}
variable "podsecuritypolicy_enabled" {
  type        = bool
  description = "pod security policy (RBAC must be enabled either by having 'RBAC' in authorization_modes or kubeadm enabled)"
  default     = false
}
variable "persistent_volumes_enabled" {
  type        = bool
  description = "Add Persistent Volumes Storage Class for corresponding cloud provider (supported: in-tree OpenStack, Cinder CSI, AWS EBS CSI, Azure Disk CSI, GCP Persistent Disk CSI)"
  default     = false
}
variable "helm_enabled" {
  type        = bool
  description = "Helm deployment"
  default     = false
}
variable "ingress_nginx_enabled" {
  type        = bool
  description = "Nginx ingress controller deployment"
  default     = false
}
variable "argocd_enabled" {
  type        = bool
  description = "ArgoCD"
  default     = false
}
variable "argocd_version" {
  type        = string
  description = "ArgoCD version"
  default     = "v2.4.12"
}
variable "ks_tmp" {
  type        = string
  description = "Kubespray temporary directory"
  default     = "kubespray/tmp"
}
variable "base64_ansible_private_key" {
  type        = string
  description = "The ansible private key for SSH based authentication in base64"
}

variable "bastion_ssh_ip" {
  type        = string
  description = "IP of the bastion host. It could be either a public IP or an internal IP that the deployment agent can reach to."
  default     = ""
}

variable "bastion_ssh_user" {
  type        = string
  description = "Username of the bastion host"
  default     = "ubuntu"
}

variable "bastion_ssh_port" {
  type        = number
  description = "SSH port of the bastion host"
  default     = 22
}