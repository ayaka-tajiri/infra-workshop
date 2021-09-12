```bash
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm repo update
```
```bash
$ helm upgrade --install -f helm/infra-workshop.yaml --namespace ingress-nginx ingress-nginx ingress-nginx/ingress-nginx
```
