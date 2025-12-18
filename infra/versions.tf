terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "3.4.0"
    }
  }
}
