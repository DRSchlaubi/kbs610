resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  account_id = var.cloudflare_account_id
  name = "kbs610"
  config_src = "cloudflare"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "this" {
  account_id   = var.cloudflare_account_id
  tunnel_id   = cloudflare_zero_trust_tunnel_cloudflared.this.id
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  account_id = var.cloudflare_account_id
  tunnel_id   = cloudflare_zero_trust_tunnel_cloudflared.this.id
  config = {
    ingress = concat(
      [ for i in range(var.worker_count) : {
          hostname = "kbs610.click"
          service  = "http://talos-worker-${i}:30080"
        }
      ],
      [ for i in range(var.worker_count) : {
          hostname = "*.kbs610.click"
          service  = "http://talos-worker-${i}:30080"
        }
      ],
      [
        {
          service = "http_status:404"
        }
      ]
    )
  }
}