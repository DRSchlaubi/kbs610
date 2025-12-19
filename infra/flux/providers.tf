terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
    }
    github = {
      source = "integrations/github"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
  }
}
