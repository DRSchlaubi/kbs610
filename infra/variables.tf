variable "controlplane_count" {
  type = number
  default = 3
}

variable "worker_count" {
  type    = number
  default = 3
}

variable "cluster_name" {
  type    = string
  default = "trainy"
}

variable "openstack_url" {
  type = string
}
variable "openstack_tenant" {
  type = string
}
variable "openstack_region" {
  type = string
  default = "RegionOne"
}
variable "openstack_app_cred_id" {
  type      = string
}
variable "openstack_app_cred_name" {
  type      = string
}
variable "openstack_app_cred_secret" {
  type      = string
  sensitive = true
}

variable "github_repo" {
  type    = string
  default = "https://github.com/DRSchlaubi/kbs610.git"
}

variable "github_org" {
  type    = string
  default = "pat"
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "google_project" {
  type    = string
  default = "kbs610"
}

variable "cluster_endpoint" {
  type    = string
  default = "https://cluster.kbs610.click:6443"
}

variable "domain_name" {
  type = string
  default = "kbs610.click"
}

variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "oauth_client_id" {
  type = string
}

variable "oauth_client_secret" {
  type = string
}
