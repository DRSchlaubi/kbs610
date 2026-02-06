# tfvars
Add a file called `infra/terraform.tfvars` which contains the necessary variables.

# gcloud
glcoud auth login

# Run the following commands
`cd infra && terraform init && terraform apply`

# File location
The generated kubeconfig file will be located at `infra/openstack/kubeconfig`,

# Usage
You can import the generated kubeconfig file into [Freelens](https://github.com/freelensapp/freelens) by going to `File -> Add cluster` (CTRL+SHIFT+A).
