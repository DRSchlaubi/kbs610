output "cf_tunnel_token" {
  value = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.token
  sensitive = true
}

output "cf_tunnel_id" {
  value = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.tunnel_id
}
