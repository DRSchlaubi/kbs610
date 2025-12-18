resource "openstack_networking_network_v2" "talos" {
  name           = "talos-network"
  admin_state_up = true
}

resource "openstack_networking_router_interface_v2" "servers" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.talos-subnet-1.id
}

resource "openstack_networking_subnet_v2" "talos-subnet-1" {
  name            = "cloudserv6-talos-subnet-1"
  network_id      = openstack_networking_network_v2.talos.id
  cidr            = "192.168.2.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_floatingip_v2" "talos-controlplanes" {
  depends_on = [openstack_networking_network_v2.talos, openstack_networking_router_interface_v2.servers]
  pool       = "ext_net"
  port_id    = openstack_networking_port_v2.talos-controlplane[count.index].id

  count = length(openstack_networking_port_v2.talos-controlplane)
}

resource "openstack_networking_floatingip_v2" "talos-workers" {
  depends_on = [openstack_networking_network_v2.talos, openstack_networking_router_interface_v2.servers]
  pool       = "ext_net"
  port_id    = openstack_networking_port_v2.talos-workers[count.index].id
  count      = length(openstack_networking_port_v2.talos-workers)
}

resource "openstack_networking_port_v2" "talos-controlplane" {
  depends_on         = [openstack_networking_subnet_v2.talos-subnet-1]
  name               = "talos-controlplane-${count.index}"
  count              = 1
  network_id         = openstack_networking_network_v2.talos.id
  admin_state_up     = true
  security_group_ids = [openstack_networking_secgroup_v2.talos_allow_all.id]
}

resource "openstack_networking_port_v2" "talos-workers" {
  depends_on         = [openstack_networking_subnet_v2.talos-subnet-1]
  name               = "talos-worker-${count.index}"
  count              = 1
  network_id         = openstack_networking_network_v2.talos.id
  admin_state_up     = true
  security_group_ids = [openstack_networking_secgroup_v2.talos_allow_all.id]
}

resource "openstack_networking_router_v2" "router" {
  name                = "talos-router"
  external_network_id = "0af64822-662d-4192-85a7-ac30d673f923"
}

resource "openstack_networking_secgroup_v2" "talos_allow_all" {
  name = "allow-all"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "talos_egress_all" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.talos_allow_all.id
}

resource "openstack_networking_secgroup_rule_v2" "talos_ingress_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.talos_allow_all.id
}
