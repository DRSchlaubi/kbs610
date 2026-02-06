module "cloudflare_argo" {
  source = "./cloudflare_argo"
  cloudflare_account_id = var.cloudflare_account_id
  cloudflare_zone_id = var.cloudflare_zone_id
  oauth_client_id = var.oauth_client_id
  oauth_client_secret = var.oauth_client_secret
  domain_name = var.domain_name
  providers = {cloudflare = cloudflare}
}

module "openstack" {
  depends_on = [module.cloudflare_argo]
  source                  = "./openstack"
  cluster_name            = var.cluster_name
  cloudflare_tunnel_token = module.cloudflare_argo.cf_tunnel_token
  cluster_endpoint        = var.cluster_endpoint
  providers               = { openstack = openstack.openstack, talos = talos.talos }
}

module "flux" {
  depends_on = [module.openstack]
  source     = "./flux"

  github_org   = var.github_org
  github_repo  = var.github_repo
  github_token = var.github_token

  openstack_url    = var.openstack_url
  openstack_tenant = var.openstack_tenant
  openstack_region = var.openstack_region
  openstack_app_cred_name = var.openstack_app_cred_name
  openstack_app_cred_id = var.openstack_app_cred_id
  openstack_app_cred_secret = var.openstack_app_cred_secret

  providers = { flux = flux.flux, cloudflare = cloudflare }
  cloudflare_account_id = var.cloudflare_account_id
  cloudflare_tunnel_id  = module.cloudflare_argo.cf_tunnel_id

  ec2_key = module.openstack.ec2_key
}

module "gcp_secrets" {
  depends_on = [module.flux]
  source     = "./gcp_secrets"

  cluster_endpoint = var.cluster_endpoint
  google_project   = var.google_project
  kubeconfig       = local.kubeconfig
  providers        = { kubernetes = kubernetes, google = google }
}
