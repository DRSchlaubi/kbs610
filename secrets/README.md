# secrets

This directory contains all secrets used in Kubernetes. For security purposes they're encrypted using
[SOPS](https://getsops.io)

By default all `.yaml` files are ignored in this directory, if you want to create a new secret, you need to encrypt
it using `./encrypt-secret.sh <raw secret file name>`

if you want to modify an existing secret you need to decrypt it first using
`sops decrypt <secret.enc.yaml> > secret.yaml`
