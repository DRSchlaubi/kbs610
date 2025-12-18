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
