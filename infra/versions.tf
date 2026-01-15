terraform {
  backend "gcs" {
    bucket = "kbs610-terraform-state"
  }

  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.10.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 3.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 7.0"
    }
    jwk = {
      source  = "jjacobelli/jwk"
      version = ">= 1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.38"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.11"
    }
  }
}
