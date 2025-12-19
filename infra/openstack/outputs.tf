resource "local_sensitive_file" "talosconfig" {
  depends_on = [data.talos_cluster_health.this]
  filename = "${path.module}/talosconfig"
  content  = data.talos_client_configuration.this.talos_config
}

resource "local_sensitive_file" "kubeconfig" {
  depends_on = [data.talos_cluster_health.this]
  filename = "${path.module}/kubeconfig"
  content  = talos_cluster_kubeconfig.this.kubeconfig_raw
}

output "kubeconfig" {
  depends_on = [data.talos_cluster_health.this]
  value = talos_cluster_kubeconfig.this
  sensitive = true
}
