terraform {
  backend "gcs" {
    bucket = "kbs610-terraform-state"
  }
}
module "openstack" {
  source       = "./openstack"
  cluster_name = var.cluster_name
  providers    = { openstack = openstack.openstack, talos = talos.talos }
}

module "flux" {
  depends_on = [module.openstack]
  source     = "./flux"

  github_org   = var.github_org
  github_repo  = var.github_repo
  github_token = var.github_token

  kubeconfig     = local.kubeconfig
  google_project = var.google_project

  providers = { flux = flux.flux }
}
