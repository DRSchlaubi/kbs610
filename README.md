# kbs610

Repo for Cloud Services Project by @7reax, @Schlauer-Hax, @Angry007, @Lele1409 and @DRSchlaubi

# Requirements
- [terraform](https://developer.hashicorp.com/terraform/install)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [talosctl](https://docs.siderolabs.com/talos/v1.8/getting-started/talosctl)
- [gcloud](https://docs.cloud.google.com/sdk/docs/install-sdk)
- [sops](https://getsops.io)

`brew install terraform kubectl talosctl gcloud-cli sops`

# Structure
- [infra](infra) - Terraform infrastructure code
- [projects](projects) - Meta directory to register all FluxCD projects
- [kube-system](kube-system) - Manifests for Kubernetes resources required to operate the cluster itself
- [secrets](secrets) - Encrypted secrets, see readme of [secrets](secrets) directory for more information


# Repo Name explanation

The current internal repo of Trainy is called "kursbuch" or KBS for short, 610 is the route number of the railway line Fulda-Frankfurt, therefore, it roughly translates to "Kursbuch Fulda".
