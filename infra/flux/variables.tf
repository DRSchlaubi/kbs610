variable "github_repo" {
  type = string
}

variable "github_org" {
  type = string
}

variable "github_token" {
  type = string
  sensitive = true
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

variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_tunnel_id" {
  type = string
}
