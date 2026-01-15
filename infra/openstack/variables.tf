variable "controlplane_count" {
  type = number
  default = 3
}
  
variable "worker_count" {
  type    = number
  default = 3
}

variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cloudflare_tunnel_token" {
  type = string
  sensitive = true
}
