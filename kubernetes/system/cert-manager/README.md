```bash
$ helm repo add jetstack https://charts.jetstack.io
$ helm repo update
```

```bash
$ helm upgrade --install -f helm/infra-workshop.yaml --namespace cert-manager --version v1.0.3 cert-manager jetstack/cert-manager
```
