variable "cluster_name" {
  type = string
  default = "trainy"
}

variable "openstack_url" {
  type = string
}
variable "openstack_username" {
  type = string
}
variable "openstack_tenant" {
  type = string
}
variable "openstack_password" {
  type = string
  sensitive = true
}

variable "github_repo" {
  type = string
  default = "https://github.com/DRSchlaubi/kbs610.git"
}

variable "github_org" {
  type = string
  default = "pat"
}

variable "github_token" {
  type = string
  sensitive = true
}

variable "google_project" {
  type = string
  default = "kbs610"
}

variable "cloudflare_tunnel_token" {
  type = string
  sensitive = true
}

variable "cluster_endpoint" {
  type = string
  default = "https://cluster.kbs610.click:6443"
}

