resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "control-planes" {
  cluster_name     = "talos-controlplane-${count.index}"
  cluster_endpoint = "https://${openstack_networking_floatingip_v2.talos-controlplanes[count.index].address}:6443"
  machine_type     = "controlplane"
  count            = length(openstack_networking_port_v2.talos-controlplane)
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = "talos-controlplane-${count.index}"
  cluster_endpoint = "https://${openstack_networking_floatingip_v2.talos-workers[count.index].address}:6443"
  machine_type     = "controlplane"
  count            = length(openstack_networking_port_v2.talos-workers)
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for e in data.talos_machine_configuration.control-planes : e.cluster_endpoint]
  nodes = [
    for cfg in concat(
      data.talos_machine_configuration.control-planes,
      data.talos_machine_configuration.worker
    ) : cfg.cluster_endpoint
  ]
}

resource "talos_machine_configuration_apply" "control-planes" {
  depends_on = [openstack_compute_instance_v2.talos-controlplanes]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control-planes[count.index].machine_configuration
  node                        = openstack_networking_floatingip_v2.talos-controlplanes[count.index].address

  count = length(openstack_networking_port_v2.talos-controlplane)
  config_patches = [
    file("${path.module}/files/enable-cloud-provider.yaml")
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on = [openstack_compute_instance_v2.talos-workers]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[count.index].machine_configuration
  node                        = openstack_networking_floatingip_v2.talos-workers[count.index].address

  count = length(openstack_networking_port_v2.talos-workers)
  config_patches = [
    file("${path.module}/files/enable-cloud-provider.yaml")
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.control-planes]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = openstack_networking_floatingip_v2.talos-workers[0].address
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = openstack_networking_floatingip_v2.talos-controlplanes[0].address
}
