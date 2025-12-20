variable "github_repo" {
  type = string
}

variable "github_org" {
  type = string
}

variable "github_token" {
  type = string
  sensitive = true
}

variable "kubeconfig" {
  type = object({
    host                   = string
    client_certificate     = string
    client_key             = string
    cluster_ca_certificate = string
  })
}

variable "google_project" {
  type = string
}
