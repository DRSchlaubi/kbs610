resource "kubernetes_secret_v1" "s3_credentials" {
  metadata {
    name        = "s3-credentials"
    namespace   = "default"
    annotations = { "replicator.v1.mittwald.de/replicate-to" = "trainy, trainy-staging" }
  }

  data = {
    "AWS_ACCESS_KEY_ID"     = var.ec2_key.id
    "AWS_SECRET_ACCESS_KEY" = var.ec2_key.secret
  }
}
