data "talos_image_factory_extensions_versions" "this" {
  talos_version = "v1.12.2"
  filters = {
    names = ["cloudflared"]
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info.*.name
        }
      }
    }
  )
}

data "talos_image_factory_urls" "this" {
  talos_version = data.talos_image_factory_extensions_versions.this.talos_version
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = "openstack"
}

resource "openstack_images_image_v2" "talos" {
  name             = "Talos"
  image_source_url = data.talos_image_factory_urls.this.urls.disk_image
  container_format = "bare"
  disk_format      = "raw"
  decompress       = "true"

  lifecycle {
    ignore_changes = [image_source_url]
  }
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
  image_id  = openstack_images_image_v2.talos.id
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
  image_id  = openstack_images_image_v2.talos.id
  flavor_id = data.openstack_compute_flavor_v2.m1-large.id

  network {
    port = openstack_networking_port_v2.talos-workers[count.index].id
  }
}
