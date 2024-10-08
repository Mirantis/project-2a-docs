# Quick Setup Guide for Azure

## Prerequisites

Before deploying Kubernetes clusters on Azure using Project 2A, ensure the following tools and configurations are set up:

1. **Install `kubectl`:**  
   Make sure `kubectl` is installed on your local machine to manage your Kubernetes clusters. You can follow the [official installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

2. **Install the Azure CLI (`az`):**  
   The `az` CLI is required to interact with Azure resources. Install it by following the [Azure CLI installation instructions](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli). Run the `az login` command to authenticate your session with Azure.

3. **Azure Account:**  
   Ensure you have access to an Azure account with the necessary permissions to manage resources. You will need to register specific resource providers, which are listed below.

## Register Resource Providers

In order to deploy and manage Kubernetes clusters, certain resource providers must be registered in your Azure subscription. Ensure the following resource providers are registered:

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
---

## Azure Cluster Parameters

The Azure Cluster Parameters are essential to configure authentication and identity management, ensuring that the **Cluster API Azure Provider (CAPZ)** can securely interact with Azure resources for provisioning and managing Kubernetes clusters.


### Cluster Identity Setup

To provide credentials for the Cluster API Azure provider (CAPZ), you need to create an `AzureClusterIdentity` resource. This is required before provisioning any clusters in Azure.

#### Create `AzureClusterIdentity`

1. **Get Your Subscription ID:**  
   To create the AzureClusterIdentity you should first get the desired SubscriptionID by executing `az account list -o table` which will return list of subscriptions available to user.

2. **Create a Service Principal:**
The service principal allows CAPZ to interact with the Azure API. To create one, run the following command, replacing <Subscription ID> with the ID retrieved in the previous step:

```bash
az ad sp create-for-rbac --role contributor --scopes="/subscriptions/<Subscription ID>"
```

This will return a JSON object containing the service principal credentials. An example response might look like:


```json
{
    "appId": "29a3a125-7848-4ce6-9be9-a4b3eecca0ff",
    "displayName": "azure-cli",
    "password": "u_RANDOMHASH",
    "tenant": "2f10bc28-959b-481f-b094-eb043a87570a"
}
```


> **Important:** Save these credentials securely, as they will be used to create the `AzureClusterIdentity` and its secret, and should be treated like passwords.

#### Create `Secret` and `AzureClusterIdentity` Resources

Use the returned credentials to create the necessary Kubernetes resources:

Secret:

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

AzureClusterIdentity:

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

#### Reference in the ManagedCluster
After creating the `AzureClusterIdentity` and its `secret`, reference them in your `ManagedCluster` resource under the `.spec.config.clusterIdentity` field.

#### Set Subscription ID
Ensure that the `SubscriptionID` used to create the service principal matches the one in the `.spec.config.subscriptionID` field of your `ManagedCluster` object.

---
## Azure Machine Parameters
To properly configure Azure VMs for your Kubernetes clusters, the following parameters allow you to define SSH access, VM size, root volume, and VM images.

### SSH Access
You can pass an SSH public key to allow access to the cluster's VMs:

- For a **hosted control plane (CP)**, set the SSH key in the `.spec.config.sshPublicKey` field.
- For a **standalone control plane**, use `.spec.config.controlPlane.sshPublicKey` for control plane nodes and `.spec.config.worker.sshPublicKey` for worker nodes.

Ensure the SSH public key is encoded in base64 format before adding it to the configuration.

### VM Size
Azure offers a variety of VM sizes suitable for different workloads. To view the available VM sizes for your location, run the following command:

```bash
az vm list-sizes --location "<location>" -o table
```

Specify your desired VM size using the appropriate parameter:

- For a **hosted CP deployment**, use `.spec.config.vmSize`.
- For a **standalone CP, use** `.spec.config.controlPlane.vmSize` for control plane nodes and `.spec.config.worker.vmSize` for worker nodes.
Example VM size: Standard_A4_v2.

### Root Volume Size
You can adjust the root volume size (in GB) of the VM using the following parameters:

- For **hosted CP**, use `.spec.config.rootVolumeSize`.
- For **standalone CP**, use `.spec.config.controlPlane.rootVolumeSize` for control plane nodes and `.spec.config.worker.rootVolumeSize` for worker nodes.

*Default value: 30 GB.*
> **Important:** The root volume size cannot be smaller than the root volume size defined in your chosen VM image.

### VM Image
You can define the image used for your VMs using the following parameters:

For a **hosted CP**, use `.spec.config.image`.
For a **standalone CP**, use `.spec.config.controlPlane.image` for control plane nodes and `.spec.config.worker.image` for worker nodes.

There are multiple ways to specify the VM image, such as using an image from the Azure Compute Gallery or Azure Marketplace. For detailed options, refer to the  [CAPZ documentation](https://capz.sigs.k8s.io/self-managed/custom-images).

By default, the latest official CAPZ Ubuntu-based image is used unless otherwise specified.

---

## Hosted Control Plane
For more advanced setups, follow the [Hosted Control Plane (Kosmotron) Guide](./hosted-control-plane.md) to configure a hosted control plane.  
> **Note:** In this setup, all control plane components for managed clusters will reside within the management cluster, offering centralized control and easier management. 
