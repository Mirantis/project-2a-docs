# Quick Setup Guide

## Prerequisites

### Required Tools

Before deploying Kubernetes clusters on Azure using Project 2A, ensure the
following tools and configurations are set up:

1. **`kubectl`:**  
   Make sure `kubectl` is installed on your local machine to manage your
   Kubernetes clusters.

    You can follow the
    [official installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

1. **Azure CLI (`az`):**  
   The `az` CLI is required to interact with Azure resources. Install it by
   following the
   [Azure CLI installation instructions](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).

    Run the `az login` command to authenticate your session with Azure.

### Azure account access

Ensure you have access to an Azure account with the necessary permissions to
manage resources. You will need to register specific resource providers, which are listed below.

### Register resource providers

In order to deploy and manage Kubernetes clusters, certain resource providers
must be registered in your Azure subscription. Ensure the following resource providers are registered:

- `Microsoft.Compute`
- `Microsoft.Network`
- `Microsoft.ContainerService`
- `Microsoft.ManagedIdentity`
- `Microsoft.Authorization`

To register these providers, you can run the following commands in the Azure CLI:

```bash
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.Authorization
```

## Configure Cluster Identity

To provide credentials for CAPI Azure provider (CAPZ) the `AzureClusterIdentity`
resource must be created. This should be done before provisioning any clusters.

To create the `AzureClusterIdentity` you should first get the desired
`SubscriptionID` by executing `az account list -o table` which will return list
of subscriptions available to user.

Then you need to create service principal which will be used by CAPZ to interact
with Azure API. To do so you need to execute the following command:

```bash
az ad sp create-for-rbac --role contributor --scopes="/subscriptions/<Subscription ID>"
```

The command will return json with the credentials for the service principal which
will look like this:

```json
{
 "appId": "29a3a125-7848-4ce6-9be9-a4b3eecca0ff",
 "displayName": "azure-cli",
 "password": "u_RANDOMHASH",
 "tenant": "2f10bc28-959b-481f-b094-eb043a87570a",
}
```

> NOTE:
> Make sure to save this credentials and treat them like passwords.

With the data from the json you can now create the `AzureClusterIdentity` object
and it's secret.

The objects created with the data above can look something like this:

**Secret**:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: az-cluster-identity-secret
  namespace: hmc-system
stringData:
  clientSecret: u_RANDOMHASH
type: Opaque
```

**AzureClusterIdentity**:

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureClusterIdentity
metadata:
  labels:
    clusterctl.cluster.x-k8s.io/move-hierarchy: "true"
  name: az-cluster-identity
  namespace: hmc-system
spec:
  allowedNamespaces: {}
  clientID: 29a3a125-7848-4ce6-9be9-a4b3eecca0ff
  clientSecret:
    name: az-cluster-identity-secret
    namespace: hmc-system
  tenantID: 2f10bc28-959b-481f-b094-eb043a87570a
  type: ServicePrincipal
```

Subscription ID which was used to create service principal should be the
same that will be used in the `.spec.config.subscriptionID` field of the
`ManagedCluster` object.

To use `AzureClusterIdentity` it should be referenced in the `Credential`
object. For more details check the [credential section](../credential/main.md).

## Azure machine parameters

Follow the [Azure machine parameters](./machine-parameters.md) guide if you want
to setup/modify the default machine parameters.

## Hosted Control Plane

For more advanced setups, follow the
[Hosted Control Plane (K0smotron) Guide](./hosted-control-plane.md) to
configure a hosted control plane.  
> NOTE:
> In this setup, all control plane components for managed clusters will
> reside within the management cluster, offering centralized control and easier management.
