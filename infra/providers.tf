locals {
  kube_data = yamldecode(module.openstack.kubeconfig.kubeconfig_raw)
  cluster = local.kube_data.clusters[0].cluster
  user = local.kube_data.users[0].user

  kubeconfig = {
    host                   = local.cluster.server
    client_certificate     = base64decode(local.user.client-certificate-data)
    client_key             = base64decode(local.user.client-key-data)
    cluster_ca_certificate = base64decode(local.cluster.certificate-authority-data)
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "openstack" {
  alias       = "openstack"
  auth_url    = var.openstack_url
  tenant_name = var.openstack_tenant
  region = var.openstack_region
  application_credential_name = var.openstack_app_cred_name
  application_credential_id = var.openstack_app_cred_id
  application_credential_secret = var.openstack_app_cred_secret
  insecure    = true
}

provider "flux" {
  alias = "flux"
  kubernetes = local.kubeconfig

  git = {
    url = "https://github.com/DRSchlaubi/kbs610.git"
    http = {
      username = "git"
      password = var.github_token
    }
  }
}

provider "talos" {
  alias = "talos"
}

provider "kubernetes" {
  client_certificate     = local.kubeconfig.client_certificate
  client_key             = local.kubeconfig.client_key
  cluster_ca_certificate = local.kubeconfig.cluster_ca_certificate
  host                   = local.kubeconfig.host
}

provider "google" {
  project = var.google_project
  region = "auto"
}
