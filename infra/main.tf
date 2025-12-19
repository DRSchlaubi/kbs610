module "openstack" {
  source       = "./openstack"
  cluster_name = var.cluster_name
  providers    = { openstack = openstack.openstack, talos = talos.talos }
}

module "flux" {
  depends_on   = [module.openstack]
  source       = "./flux"

  github_org   = var.github_org
  github_repo  = var.github_repo
  github_token = var.github_token

  providers    = { flux = flux.flux, github = github.github }
}
