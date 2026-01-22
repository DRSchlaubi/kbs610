terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    jwk = {
      source = "jjacobelli/jwk"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
    }
  }
}
