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
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.7"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.6"
    }
  }
}
