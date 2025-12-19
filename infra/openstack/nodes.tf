resource "openstack_images_image_v2" "talos-1116" {
  name             = "Talos v1.11.6"
  # Created via https://factory.talos.dev/?arch=amd64&cmdline-set=true&extensions=-&platform=openstack&target=cloud&version=1.11.6
  image_source_url = "https://factory.talos.dev/image/376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba/v1.11.6/openstack-amd64.raw.xz"
  container_format = "bare"
  disk_format      = "raw"
  decompress       = "true"
}

data "openstack_compute_flavor_v2" "m1-medium" {
  name = "m1.medium"
}
data "openstack_compute_flavor_v2" "m1-large" {
  name = "m1.large"
}

resource "openstack_compute_instance_v2" "talos-controlplanes" {
  depends_on = [openstack_networking_floatingip_v2.talos-controlplanes]
  name      = "talos-controlplane-${count.index}"
  image_id  = openstack_images_image_v2.talos-1116.id
  flavor_id = data.openstack_compute_flavor_v2.m1-medium.id
  count = length(openstack_networking_port_v2.talos-controlplanes)

  network {
    port = openstack_networking_port_v2.talos-controlplanes[count.index].id
  }
}

resource "openstack_compute_instance_v2" "talos-workers" {
  depends_on = [openstack_networking_floatingip_v2.talos-workers]
  count = length(openstack_networking_port_v2.talos-workers)
  name      = "talos-worker-${count.index}"
  image_id  = openstack_images_image_v2.talos-1116.id
  flavor_id = data.openstack_compute_flavor_v2.m1-large.id

  network {
    port = openstack_networking_port_v2.talos-workers[count.index].id
  }
}
