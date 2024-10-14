
## TL;DR

```bash
kubectl apply -f https://github.com/Mirantis/hmc/releases/download/v0.0.1/install.yaml
```

or install using `helm`

```bash
helm install hmc oci://ghcr.io/mirantis/hmc/charts/hmc --version v0.0.1 -n hmc-system --create-namespace
```

> NOTE:
> The HMC installation using Kubernetes manifests does not allow customization of
> the deployment. If the custom HMC configuration should be applied, install HMC
> using the Helm chart.
