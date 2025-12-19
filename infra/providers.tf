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

provider "openstack" {
  alias       = "openstack"
  auth_url    = var.openstack_url
  tenant_name = var.openstack_username
  user_name   = var.openstack_username
  password    = var.openstack_password
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
