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
    google = {
      source  = "hashicorp/google"
      version = "7.14.1"
    }
    jwk = {
      source  = "jjacobelli/jwk"
      version = "1.1.9"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}
