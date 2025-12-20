# kbs610

Repo for Cloud Services Project by @7reax, @Schlauer-Hax, @Angry007 and @DRSchlaubi

# Requirements
- [terraform](https://developer.hashicorp.com/terraform/install)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [talosctl](https://docs.siderolabs.com/talos/v1.8/getting-started/talosctl)
- [gcloud](https://docs.cloud.google.com/sdk/docs/install-sdk)
- [sops](https://getsops.io)

# Structure
- [infra](infra) - Terraform infrastructure code
- [projects](projects) - Meta directory to register all FluxCD projects
- [kube-sytem](kube-system) - Manifests for Kubernetes resources required to operate the cluster itself

# Secret management

Secrets are stored in this repo itself, for security reasons they're 
encrypted using [SOPS](https://getsops.io) using an encryption 
key stored in [GCP KMS](https://cloud.google.com/security/products/security-key-management?hl=de)

To create a secret make sure both `gcloud` and `sops` are installed and run:
`./encrypt-secret.sh <file to encrypt>` or `.\encrypt-secret.ps1 <file to encrypt>`

# Repo Name explanation

The current internal repo of Trainy is called "kursbuch" or KBS for short, 610 is the route number of the railway line Fulda-Frankfurt, therefore, it roughly translates to "Kursbuch Fulda".
