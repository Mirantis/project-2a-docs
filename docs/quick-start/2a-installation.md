## Quick Start

### Installation via Helm
To begin the installation, use Helm to deploy 2A from the specified OCI registry:
```bash
helm install hmc oci://ghcr.io/mirantis/hmc/charts/hmc --version 0.0.3 -n hmc-system --create-namespace
```
> If you want to adjust the configuration, please check the [installation guide](../usage/installation.md).

### Verification

The installation process takes a few minutes to fully complete, as 2A and its subcomponents are installed and configured.

To verify that all components are up and running, check the status of the pods within the `hmc-system` namespace. Run the following command:

```bash
kubectl get pods -n hmc-system
```

The output is similar to:

```bash
NAME                                                           READY   STATUS
azureserviceoperator-controller-manager-86d566cdbc-rqkt9       1/1     Running
capa-controller-manager-7cd699df45-28hth                       1/1     Running
capi-controller-manager-6bc5fc5f88-hd8pv                       1/1     Running
capv-controller-manager-bb5ff9bd5-7dsr9                        1/1     Running
capz-controller-manager-5dd988768-qjdbl                        1/1     Running
helm-controller-76f675f6b7-4d47l                               1/1     Running
hmc-cert-manager-7c8bd964b4-nhxnq                              1/1     Running
hmc-cert-manager-cainjector-56476c46f9-xvqhh                   1/1     Running
hmc-cert-manager-webhook-69d7fccf68-s46w8                      1/1     Running
hmc-cluster-api-operator-79459d8575-2s9jc                      1/1     Running
hmc-controller-manager-64869d9f9d-zktgw                        1/1     Running
k0smotron-controller-manager-bootstrap-6c5f6c7884-d2fqs        2/2     Running
k0smotron-controller-manager-control-plane-857b8bffd4-zxkx2    2/2     Running
k0smotron-controller-manager-infrastructure-7f77f55675-tv8vb   2/2     Running
source-controller-5f648d6f5d-7mhz5                             1/1     Running
```

If you have fewer pods, give 2A more time to reconcile all the pods.

As a second verification, check that the example `ClusterTemplate` objects have been installed and are valid:

```bash
kubectl get clustertemplate -n hmc-system
```

The output is similar to:

```bash
NAME                                VALID
aws-eks-0-0-1                       true
aws-hosted-cp-0-0-2                 true
aws-standalone-cp-0-0-1             true
aws-standalone-cp-0-1-0             true
azure-hosted-cp-0-0-3               true
azure-standalone-cp-0-0-1           true
azure-standalone-cp-0-1-0           true
remote-single-standalone-cp-0-1-4   true
remote-single-standalone-cp-0-1-5   true
remote-single-standalone-cp-0-1-6   true
remote-single-standalone-cp-0-1-7   true
remote-single-standalone-cp-0-1-8   true
vsphere-hosted-cp-0-0-2             true
vsphere-standalone-cp-0-0-2         true
```

### Next Step

Now you can configure your Infrastructure Provider of choice and create your first Managed Cluster.

Jump to any of the following Infrastructure Providers for specific instructions:

- [AWS Quick Start](aws.md)
- [Azure Quick Start](azure.md)
- [vSphere Quick Start](vsphere.md)
