resource "talos_machine_secrets" "this" {}

locals {
  control-plane-floating-ips = [for i in range(length(openstack_networking_floatingip_v2.talos-controlplanes)) : openstack_networking_floatingip_v2.talos-controlplanes[i].address]
  control-plane-ips          = [for i in range(length(openstack_compute_instance_v2.talos-controlplanes)) : openstack_compute_instance_v2.talos-controlplanes[i].network[0].fixed_ip_v4]
  worker-floating-ips        = [for i in range(length(openstack_networking_floatingip_v2.talos-workers)) : openstack_networking_floatingip_v2.talos-workers[i].address]
  worker-ips                 = [for i in range(length(openstack_compute_instance_v2.talos-workers)) : openstack_compute_instance_v2.talos-workers[i].network[0].fixed_ip_v4]

  rendered-cloudflare-config = templatefile("${path.module}/files/cloudflared-config.yaml.tftpl", {
    tunnel_token = var.cloudflare_tunnel_token
  })

  rendered-cluster-jwts = templatefile("${path.module}/files/cluster-auth.yaml.tftpl", {
    cluster_endpoint = var.cluster_endpoint
    control_plane_api_audiences = join(",", [
      for i in range(length(local.control-plane-floating-ips)) :"https://${local.control-plane-floating-ips[i]}:6443"
    ])
  })
}

data "talos_machine_configuration" "control-planes" {
  cluster_name     = "talos-controlplane-${count.index}"
  cluster_endpoint = "https://${local.control-plane-floating-ips[count.index]}:6443"
  machine_type     = "controlplane"
  count            = length(openstack_compute_instance_v2.talos-controlplanes)
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = "talos-controlplane-${count.index}"
  cluster_endpoint = "https://${local.worker-floating-ips[count.index]}:6443"
  machine_type     = "worker"
  count            = length(openstack_compute_instance_v2.talos-workers)
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [local.control-plane-floating-ips[0]]
  nodes                = concat(local.control-plane-ips, local.worker-ips)
}

resource "talos_machine_configuration_apply" "control-planes" {
  depends_on                  = [openstack_compute_instance_v2.talos-controlplanes]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control-planes[count.index].machine_configuration
  node                        = local.worker-ips[count.index]
  endpoint                    = local.control-plane-floating-ips[count.index]

  count = length(local.control-plane-floating-ips)

  config_patches = [
    file("${path.module}/files/enable-cloud-provider.yaml"),
    file("${path.module}/files/enable-swap.yaml"),
    local.rendered-cluster-jwts,
    yamlencode({
      machine = {
        certSANs = [
          local.control-plane-ips[count.index],
          local.control-plane-floating-ips[count.index]
        ]
      }
      cluster = {
        apiServer = {
          certSANs = [
            local.control-plane-ips[count.index],
            local.control-plane-floating-ips[count.index]
          ]
        }
      }
    }),
    local.rendered-cloudflare-config
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on                  = [openstack_compute_instance_v2.talos-workers]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[count.index].machine_configuration
  node                        = local.worker-ips[count.index]
  endpoint                    = local.worker-floating-ips[count.index]

  count = length(openstack_networking_port_v2.talos-workers)
  config_patches = [
    file("${path.module}/files/enable-cloud-provider.yaml"),
    local.rendered-cloudflare-config
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.control-planes]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = openstack_networking_floatingip_v2.talos-controlplanes[0].address
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = openstack_networking_floatingip_v2.talos-controlplanes[0].address
}

data "talos_cluster_health" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = data.talos_client_configuration.this.client_configuration
  control_plane_nodes = local.control-plane-ips
  worker_nodes = local.worker-ips
  endpoints = [local.control-plane-floating-ips[0]]
}
