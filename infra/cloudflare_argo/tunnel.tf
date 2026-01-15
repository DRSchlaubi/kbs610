resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  account_id = var.cloudflare_account_id
  name = "kbs610"
  config_src = "local"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "this" {
  account_id   = var.cloudflare_account_id
  tunnel_id   = cloudflare_zero_trust_tunnel_cloudflared.this.id
}
