```bash
$ helm repo add external-secrets https://external-secrets.github.io/kubernetes-external-secrets
$ helm update
```

```bash
$ helm upgrade external-secrets external-secrets/kubernetes-external-secrets --install -f system/external-secrets/helm/staging.yaml --namespace external-secrets
```
