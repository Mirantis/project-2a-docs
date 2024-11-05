# AWS Quick Start

## Prerequisites

## 2A Management Cluster

You need an k8s cluster with [2A installed](2a-installation.md).

## Software prerequisites

- AWS clusterawsadm (`clusterawsadm`): The `clusterawsadm` CLI is required to
bootstrap an AWS Account. Install it by following the
[AWS clusterawsadm installation instructions](https://github.com/kubernetes-sigs/cluster-api-provider-aws?tab=readme-ov-file#clusterawsadm).

## Configure AWS IAM

Before launching a cluster on AWS, you need to set up your AWS infrastructure
with the necessary IAM policies and service account.

> NOTE:
> Skip steps below if you've already configured IAM policy for your AWS account

1. In order to use clusterawsadm you must have an administrative user in an AWS
   account. Once you have that administrator user you need to set your
   environment variables:

```
export AWS_REGION=<aws-region>
export AWS_ACCESS_KEY_ID=<admin-user-access-key>
export AWS_SECRET_ACCESS_KEY=<admin-user-secret-access-key>
export AWS_SESSION_TOKEN=<session-token> # Optional. If you are using Multi-Factor Auth.
```

2. After these are set run this command to create IAM cloud formation stack:

```
clusterawsadm bootstrap iam create-cloudformation-stack
```


## Step 1: Create AWS IAM User

1. Create an AWS IAM user assigne the following roles:

    - `control-plane.cluster-api-provider-aws.sigs.k8s.io`
    - `controllers.cluster-api-provider-aws.sigs.k8s.io`
    - `nodes.cluster-api-provider-aws.sigs.k8s.io`


2. Create Access Keys for the IAM user

    In the AWS IAM Console create the Access Keys for the IAM user and download
    them.

    You should have a `AccessKeyID` and a `SecretAccessKey` that looks like the
    following:

    ```
    Access key ID,Secret access key
    AKIAQF+EXAMPLE, EdJfFar6+example
    ```

## Step 2: Create the IAM Credentials secret on 2A management cluster

Save the Secret YAML into a file named `aws-cluster-identity-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: aws-cluster-identity-secret
  namespace: hmc-system
type: Opaque
stringData:
  AccessKeyID: AKIAQF+EXAMPLE
  SecretAccessKey: EdJfFar6+example
```

Apply the YAML to your cluster using the following command:

```bash
kubectl apply -f aws-cluster-identity-secret.yaml
```

> NOTE:
> The secret must be created in the same `Namespace` where CAPA provider is
> running. In case of Project 2A it's currently `hmc-system`. Placing secret in
> any other `Namespace` will result controller not able to read it.

## Step 3: Create AWSClusterStaticIdentity Object

Save the AWSClusterIdentity YAML into a file named `aws-cluster-identity.yaml`:

> NOTE:
> The `secretRef` must match the `name` of the secret that was created in the
> previous step

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSClusterStaticIdentity
metadata:
  name: aws-cluster-identity
spec:
  secretRef: aws-cluster-identity-secret
  allowedNamespaces:
    selector:
      matchLabels: {}
```

Apply the YAML to your cluster:

```bash
kubectl apply -f aws-cluster-identity.yaml
```

## Step 4: Create the 2A Credential Object


Create a YAML with the specificaion of our credential and safe it as
`aws-cluster-identity-cred.yaml`

> NOTE:
> The `kind:` must be `AWSClusterStaticIdentity` and the `name:` must match of
> the `AWSClusterStaticIdentity` object.

```yaml
apiVersion: hmc.mirantis.com/v1alpha1
kind: Credential
metadata:
  name: aws-cluster-identity-cred
  namespace: hmc-system
spec:
  description: "Credential Example"
  identityRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
    kind: AWSClusterStaticIdentity
    name: aws-cluster-identity
```

Apply the YAML to your cluster:

```bash
kubectl apply -f aws-cluster-identity-cred.yaml
```


## Step 5: Create the first managedCluster

Create a YAML with the specificaion of your managed Cluster and safe it as
`my-aws-managedcluster1.yaml`

```yaml
apiVersion: hmc.mirantis.com/v1alpha1
kind: ManagedCluster
metadata:
  name: my-aws-managedcluster1
  namespace: hmc-system
spec:
  template: aws-standalone-cp-0-0-2
  credential: aws-cluster-identity-cred
  config:
    region: us-west-2
    controlPlane:
      instanceType: t3.small
    worker:
      instanceType: t3.small
```

Follow along the creation of the cluster

```bash
kubectl -n hmc-system get managedcluster.hmc.mirantis.com my-aws-managedcluster1  --watch
```

After the cluster is `Ready` you can access it via the kubeconfig, like this:

```bash
kubectl -n hmc-system get secret my-aws-managedcluster1-kubeconfig -o jsonpath='{.data.value}' | base64 -d > my-aws-managedcluster1-kubeconfig.kubeconfig
KUBECONFIG="my-aws-managedcluster1-kubeconfig.kubeconfig" kubectl get pods -A
```

You can also retrieve the kubeconfig via clusterctl:
```bash
clusterctl get kubeconfig my-aws-managedcluster1 -n hmc-system > my-aws-managedcluster1-kubeconfig.kubeconfig
```
