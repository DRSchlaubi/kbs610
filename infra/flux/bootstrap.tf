resource "flux_bootstrap_git" "this" {
  embedded_manifests = true
  path               = "."
  kustomization_override = file("${path.module}/resources/bootstrap-toleration.yaml")

}
