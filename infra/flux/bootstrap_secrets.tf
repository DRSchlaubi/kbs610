resource "kubernetes_secret_v1" "osccm" {
  metadata {
    name = "cloud-config"
    namespace = "kube-system"
  }

  data = {
    "cloud.conf" = <<EOF
    [Global]
    auth-url=${var.openstack_url}
    application-credential-name=${var.openstack_app_cred_name}
    application-credential-id=${var.openstack_app_cred_id}
    application-credential-secret=${var.openstack_app_cred_secret}

    region=${var.openstack_region}
    tenant-id=${var.openstack_tenant}
    tls-insecure=true
    [Networking]
    EOF
  }
}
