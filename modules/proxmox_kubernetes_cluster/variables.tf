variable "pm_host" {}
variable "pm_api_url" {}
variable "pm_api_token_id" {}
variable "pm_api_token_secret" {}
variable "pm_tls_insecure" {}
variable "worker" {
  type        = map(any)
  description = "Worker VM configuration settings"
}
variable "control_plane" {
  type        = map(any)
  description = "control plane VM configuration settings"
}
variable "name" {
  type        = string
  description = "Kubernetes cluster name"
}