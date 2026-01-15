resource "flux_bootstrap_git" "this" {
  depends_on = [kubernetes_secret_v1.osccm]
  embedded_manifests = true
  path               = "."
  kustomization_override = file("${path.module}/resources/flux-kustomization-patches.yaml")
}
