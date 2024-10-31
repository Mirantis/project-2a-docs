# Azure Quick Start

## Prerequisites

### Software prerequisites

Before we begin, deploying Kubernetes clusters on Azure using Project 2A, make
sure you have:

- Azure CLI (`az`): The `az` CLI is required to interact with Azure
resources. Install it by following the [Azure CLI installation
instructions](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).

   Run the `az login` command to authenticate your session with Azure.

### Register resource providers

If you're using a brand new subscription that has never been used to deploy 2A
or CAPI clusters, register these services ensure the following resource
providers are registered:

- `Microsoft.Compute`
- `Microsoft.Network`
- `Microsoft.ContainerService`
- `Microsoft.ManagedIdentity`
- `Microsoft.Authorization`

To register these providers, you can run the following commands in the Azure
CLI:

```bash
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.Authorization
```

You can follow the [official documentation guide](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types)
to register the providers.

Before you can create a cluster on Azure, you need to set up credentials.
This involves creating an `AzureClusterIdentity` and a `Service Principal (SP)`
to let CAPZ (Cluster API Azure) communicate with Azure.

## Step 1: Find Your Subscription ID

List all your Azure subscriptions:

```bash
az account list -o table
```

Look for the Subscription ID of the account you want to use.

Example output:

```diff
Name                     SubscriptionId                        TenantId
-----------------------  -------------------------------------  --------------------------------
My Azure Subscription    12345678-1234-5678-1234-567812345678  87654321-1234-5678-1234-12345678
```

Copy your chosen Subscription ID for the next step.

## Step 2: Create a Service Principal (SP)

The Service Principal is like a password-protected user that CAPZ will use to
manage resources on Azure.

In your terminal, run the following command. Make sure to replace <Subscription
ID> with the ID you copied earlier:

```bash
az ad sp create-for-rbac --role contributor --scopes="/subscriptions/<Subscription ID>"
```

You will see output like this:

```json
{
 "appId": "12345678-7848-4ce6-9be9-a4b3eecca0ff",
 "displayName": "azure-cli-2024-10-24-17-36-47",
 "password": "12~34~I5zKrL5Kem2aXsXUw6tIig0M~3~1234567",
 "tenant": "12345678-959b-481f-b094-eb043a87570a",
}
```

> NOTE:
> Make sure to treat these strings like passwords.

## Step 3: Create a Secret Object with the password

The Secret stores the clientSecret (password) from the Service Principal.

Save the Secret YAML into a file named `azure-cluster-identity-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: azure-cluster-identity-secret
  namespace: hmc-system
stringData:
  clientSecret: <password> # Password retrieved from the Service Principal
type: Opaque
```

Apply the YAML to your cluster using the following command:

```bash
kubectl apply -f azure-cluster-identity-secret.yaml
```

## Step 4: Create the AzureClusterIdentity Object

This object defines the credentials CAPZ will use to manage Azure resources.

Save the AzureClusterIdentity YAML into a file named
`azure-cluster-identity.yaml`:

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureClusterIdentity
metadata:
  labels:
    clusterctl.cluster.x-k8s.io/move-hierarchy: "true"
  name: azure-cluster-identity
  namespace: hmc-system
spec:
  allowedNamespaces: {}
  clientID: <appId> # AppId retrieved from the Service Principal
  clientSecret:
    name: azure-cluster-identity-secret
    namespace: hmc-system
  tenantID: <tenant> # TennantID retrieved from the Service Principal
  type: ServicePrincipal
```

Apply the YAML to your cluster:

```bash
  kubectl apply -f azure-cluster-identity.yaml
```

## Step 5: Create the 2A Credential Object

Create a YAML with the specificaion of our credential and safe it as
`azure-cluster-identity-cred.yaml`

> NOTE:
> The `kind:` must be `AzureClusterIdentity` and the `name:` must match of the
> `AzureClusterIdentity` object.

```yaml
apiVersion: hmc.mirantis.com/v1alpha1
kind: Credential
metadata:
  name: azure-cluster-identity-cred
  namespace: hmc-system
spec:
  identityRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AzureClusterIdentity
    name: azure-cluster-identity
    namespace: hmc-system
```

Apply the YAML to your cluster:

```bash
kubectl apply -f aws-cluster-identity-cred.yaml
```

## Step 6: Create the first managedCluster

Create a YAML with the specificaion of your managed Cluster and safe it as
`my-azure-managedcluster1.yaml`

```yaml
apiVersion: hmc.mirantis.com/v1alpha1
kind: ManagedCluster
metadata:
  name: my-azure-managedcluster1
  namespace: hmc-system
spec:
  template: azure-standalone-cp-0-0-3
  credential: azure-cluster-identity-cred
  config:
    location: "westus" # Select your desired Azure Location (find it via `az account list-locations -o table`)
    subscriptionID: <Subscription ID> # Enter the Subscription ID used earlier
    controlPlane:
      vmSize: Standard_A4_v2
    worker:
      vmSize: Standard_A4_v2
```

Follow along the creation of the cluster

```bash
kubectl -n hmc-system get managedcluster.hmc.mirantis.com my-azure-managedcluster1  --watch
```

After the cluster is `Ready` you can access it via the kubeconfig, like this:

```bash
kubectl -n hmc-system get secret my-azure-managedcluster1-kubeconfig -o jsonpath='{.data.value}' | base64 -d > my-azure-managedcluster1-kubeconfig.kubeconfig
KUBECONFIG="my-azure-managedcluster1-kubeconfig.kubeconfig" kubectl get pods -A
```
