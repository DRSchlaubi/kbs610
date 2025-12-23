resource "local_sensitive_file" "talosconfig" {
  filename = "${path.module}/talosconfig"
  content  = data.talos_client_configuration.this.talos_config
}

resource "local_sensitive_file" "kubeconfig" {
  filename = "${path.module}/kubeconfig"
  content  = talos_cluster_kubeconfig.this.kubeconfig_raw
}

output "kubeconfig" {
  value = talos_cluster_kubeconfig.this
  sensitive = true
}
