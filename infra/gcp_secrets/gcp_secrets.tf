locals {
  jwks = jsonencode({ keys : jsondecode("[${join(", ", data.jwk_from_k8s.this.jwks)}]") })
}
data "jwk_from_k8s" "this" {
  client_certificate     = var.kubeconfig.client_certificate
  client_key             = var.kubeconfig.client_key
  cluster_ca_certificate = var.kubeconfig.cluster_ca_certificate
  host                   = var.kubeconfig.host
}

resource "google_project_service" "iamcredentials" {
  project = var.google_project
  service = "iamcredentials.googleapis.com"
}

resource "google_iam_workload_identity_pool" "kubernetes" {
  # Deleting just marks them as deleted, but they actually still exist, so we need to rename it each time
  workload_identity_pool_id = "kubernetes-v9"
}

resource "google_iam_workload_identity_pool_provider" "kubernetes-oidc" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.kubernetes.workload_identity_pool_id
  workload_identity_pool_provider_id = "kubernetes-oidc"

  oidc {
    issuer_uri = var.cluster_endpoint
    // "jwks" is a list of single key objects, however GCP expects {"keys": [<objects...>]}
    jwks_json = local.jwks
  }

  attribute_mapping = {
    "attribute.service_account_name" : "assertion['kubernetes.io']['serviceaccount']['name']"
    "attribute.namespace" : "assertion['kubernetes.io']['namespace']"
    "google.subject" : "assertion.sub"
    "attribute.pod" : "assertion['kubernetes.io']['pod']['name']"
  }

  // FOr some reason this always detects changed, even though none are there
  lifecycle {
    ignore_changes = [oidc[0].jwks_json]
  }
}

resource "google_service_account" "flux" {
  account_id = "fluxcd-secrets-decryptor"
}

resource "google_project_iam_member" "kms_service_agent" {
  project = var.google_project
  role    = "roles/cloudkms.cryptoKeyDecrypter"
  member  = "serviceAccount:${google_service_account.flux.email}"
}

resource "kubernetes_service_account_v1" "secrets-decryptor" {
  metadata {
    namespace = "flux-system"
    name      = "secrets-decryptor"
    annotations = {
      "iam.gke.io/gcp-service-account"                = google_service_account.flux.email
      "gcp.auth.fluxcd.io/workload-identity-provider" = google_iam_workload_identity_pool_provider.kubernetes-oidc.name
    }
  }
}

resource "google_service_account_iam_member" "workload_identity_binding" {
  depends_on         = [google_iam_workload_identity_pool_provider.kubernetes-oidc]
  service_account_id = google_service_account.flux.id

  role   = "roles/iam.workloadIdentityUser"
  member = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.kubernetes.name}/subject/system:serviceaccount:${kubernetes_service_account_v1.secrets-decryptor.metadata[0].namespace}:${kubernetes_service_account_v1.secrets-decryptor.metadata[0].name}"
}


resource "kubernetes_manifest" "flux_secrets_kustomization" {
  depends_on = [google_service_account_iam_member.workload_identity_binding, google_project_service.iamcredentials]
  manifest = {
    "apiVersion" = "kustomize.toolkit.fluxcd.io/v1"
    "kind"       = "Kustomization"
    "metadata" = {
      "name"      = "secrets"
      "namespace" = "flux-system"
    }
    "spec" = {
      "interval" = "10m0s"
      "path"     = "./secrets"
      "prune"    = true
      "sourceRef" = {
        "kind"      = "GitRepository"
        "name"      = "flux-system"
        "namespace" = "flux-system"
      }
      "dependsOn" = [
        {
          "name" = "flux-system",
          "namespace" = "flux-system"
        }
      ]
      "decryption" = {
        "provider"           = "sops"
        "serviceAccountName" = kubernetes_service_account_v1.secrets-decryptor.metadata[0].name
      }
    }
  }
}
