# Credential system

In order for infrastructure provider to work properly a correct credentials
should be passed to it. The following describes how it is implemented in 2A.

## The process

The following is the process of passing credentials to the system:

1. Provider specific `ClusterIdentity` and `Secret` are created
2. `Credential` object is created referencing `ClusterIdentity` from step **1**.
3. The `Credential` object is then referenced in the `ManagedCluster`.

By design steps 1 and 2 should be executed by the platform lead engender who has
access to the credentials. Thus credentials could be used by platform engineers
without a need to have access to actual credentials or underlying resources,
like `ClusterIndentity`.

## Credential object

The `Credential` object acts like a reference to the underlying credentials. It
is namespace-scoped, which means that it must be in the same `Namespace` with
the `ManagedCluster` it is referenced in. Actual credentials can be located in
any namespace.

### Example

```yaml
---
apiVersion: hmc.mirantis.com/v1alpha1
kind: Credential
metadata:
  name: azure-credential
  namespace: dev
spec:
  description: "Main Azure credentials"
  identityRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AzureClusterIdentity
    name: azure-cluster-identity
    namespace: hmc-system
```

In the example above `Credential` object is referencing `AzureClusterIdentity`
which was created in the `hmc-system` namespace.

The `.spec.description` field can be used to provide arbitrary description of the
object, so user could make a decision which credentials to use if several are
present.
