resource "cloudflare_zero_trust_access_identity_provider" "git-ce" {
  config = {
    claims           = ["email"]
    client_id        = var.oauth_client_id
    client_secret    = var.oauth_client_secret
    email_claim_name = "email"
    scopes = [
      "openid",
      "email",
      "profile",
    ]

    auth_url  = "https://git-ce.rwth-aachen.de/oauth/authorize",
    token_url = "https://git-ce.rwth-aachen.de/oauth/token",
    certs_url = "https://git-ce.rwth-aachen.de/oauth/discovery/keys",
  }
  name    = "git-ce.rwth-aachen.de"
  type    = "oidc"
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_zero_trust_access_policy" "hs-fulda-email" {
  account_id = var.cloudflare_account_id
  decision   = "allow"
  include = [{
    email_domain = { domain = "informatik.hs-fulda.de" }
  }]
  name             = "hs-fulda-email"
  session_duration = "24h"
}

resource "cloudflare_zero_trust_access_policy" "github-ip" {
  account_id = var.cloudflare_account_id
  decision   = "bypass"
  # https://api.github.com/meta
  include = [
    { ip = { ip = "192.30.252.0/22" } },
    { ip = { ip = "185.199.108.0/22" } },
    { ip = { ip = "140.82.112.0/20" } },
    { ip = { ip = "143.55.64.0/20" } },
    { ip = { ip = "2a0a:a440::/29" } },
    { ip = { ip = "2606:50c0::/32" } }
  ]
  name             = "github-ip"
  session_duration = "10m"
}

resource "cloudflare_zero_trust_access_policy" "hs-fulda-ip" {
  account_id = var.cloudflare_account_id
  decision   = "bypass"
  include = [
    { ip = { ip = "192.108.48.0/24" } },
    { ip = { ip = "2001:638::/32" } }
  ]
  name             = "hs-fulda-ip"
  session_duration = "1h"
}

resource "cloudflare_zero_trust_access_application" "this" {
  domain                    = var.domain_name
  type                      = "self_hosted"
  zone_id                   = var.cloudflare_zone_id
  allowed_idps              = [cloudflare_zero_trust_access_identity_provider.git-ce.id]
  auto_redirect_to_identity = true
  session_duration          = "24h"
  policies = [
    { id = cloudflare_zero_trust_access_policy.github-ip.id },
    { id = cloudflare_zero_trust_access_policy.hs-fulda-ip.id },
    { id = cloudflare_zero_trust_access_policy.hs-fulda-email.id }
  ]
  destinations = [{
    type = "public"
    uri  = var.domain_name
    }, {
    type = "public"
    uri  = "*.${var.domain_name}"
  }]
}
