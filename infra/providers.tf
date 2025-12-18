provider "talos" {}
provider "openstack" {
  auth_url    = var.openstack_url
  tenant_name = var.openstack_tenant
  user_name   = var.openstack_username
  password    = var.openstack_password
  insecure    = true // TODO: remove
  region      = "RegionOne"
}
