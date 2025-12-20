terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
    }
    google = {
      source = "hashicorp/google"
    }
    jwk = {
      source = "jjacobelli/jwk"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
