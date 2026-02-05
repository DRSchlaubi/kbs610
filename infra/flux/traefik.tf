data "kubernetes_namespace_v1" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "kubernetes_service_v1" "traefik" {
  depends_on = [flux_bootstrap_git.this]
  metadata {
    name      = "traefik"
    namespace = data.kubernetes_namespace_v1.ingress.metadata[0].name

    annotations = {
      "loadbalancer.openstack.org/proxy-protocol" = "true"
    }
  }

  spec {
    type = "LoadBalancer"

    port {
      name        = "web"
      port        = 80
      target_port = "web"
      protocol    = "TCP"
    }
    port {
      name        = "websecure"
      port        = 443
      target_port = "websecure"
      protocol    = "TCP"
    }

    selector = {
      "app.kubernetes.io/instance" = "traefik-ingress"
      "app.kubernetes.io/name"     = "traefik"
    }
  }
}


resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  account_id = var.cloudflare_account_id
  tunnel_id  = var.cloudflare_tunnel_id
  config = {
    ingress = [
      {
        hostname = "kbs610.click"
        service  = "http://${kubernetes_service_v1.traefik.status[0].load_balancer[0].ingress[0].ip}:80"
      },
      {
        hostname = "*.kbs610.click"
        service  = "https://${kubernetes_service_v1.traefik.status[0].load_balancer[0].ingress[0].ip}:443"
        origin_request = {
          no_tls_verify = true
        }
      },
      {
        service = "http_status:404"
      }
    ]
  }
}
