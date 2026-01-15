terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    jwk = {
      source  = "jjacobelli/jwk"
    }
  }
}
