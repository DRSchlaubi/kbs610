resource "openstack_identity_ec2_credential_v3" "this" {
  user_id = data.openstack_identity_auth_scope_v3.current.user_id
}

resource "openstack_objectstorage_container_v1" "container_1" {
  name   = "trainy-backup-container-1"
}

data "openstack_identity_auth_scope_v3" "current" {
  name = "current"
}
