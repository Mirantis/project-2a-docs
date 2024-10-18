# AWS cluster parameters

## Software prerequisites

1. `clusterawsadm` CLI installed locally.
2. `kubectl` CLI installed locally

## Cluster Identity 

> NOTE:
> Full details on the Credentials system can be found in the [Credential System Guide](/credential/main/)

To provide credentials for CAPI AWS provider (CAPA) `ClusterIdentity` object
must be created.

AWS provider supports 3 types of `ClusterIdentity`, which one to use depends on
your specific use case. More information regarding CAPA `ClusterIdentity`
resources could be found in [CRD Reference](https://cluster-api-aws.sigs.k8s.io/crd/).

## AWS Cluster Static Identity Example

### Create AWS IAM User
> In this example we're using [`AWSClusterStaticIdentity`](https://cluster-api-aws.sigs.k8s.io/crd/#infrastructure.cluster.x-k8s.io/v1beta1.AWSClusterStaticIdentity).

1. Create a AWS IAM user to use as service account

    A IAM user must be created and assigned the following roles:
    > Follow the [IAM setup guide](cloudformation.md#aws-iam-setup) (if not already done)
to create these roles.

    - `control-plane.cluster-api-provider-aws.sigs.k8s.io`
    - `controllers.cluster-api-provider-aws.sigs.k8s.io`
    - `nodes.cluster-api-provider-aws.sigs.k8s.io`
  

2. Create Access Keys for the IAM user

    In the AWS IAM Console create the Access Keys for the IAM user and download them.

    You should have a `AccessKeyID` and a `SecretAccessKey` that looks like the following
    ```
    Access key ID,Secret access key
    AKIAQF+EXAMPLE, EdJfFar6+example 
    ```

### Create the IAM Credentials on Kubernetes 

1. Next the following secret should be created with the user's credentials
  
    > The `name:` entry must be unique

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

    > NOTE:
    > The secret must be created in the same `Namespace` where CAPA provider is
    > running. In case of Project 2A it's currently `hmc-system`. Placing secret in
    > any other `Namespace` will result controller not able to read it.

2. Then `AWSClusterStaticIdentity` must be created

    > The `secretRef` must match the `name` of the secret that was created in the previous step

    ```yaml
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
    kind: AWSClusterStaticIdentity
    metadata:
      name: aws-cluster-identity
      namespace: hmc-system
    spec:
      secretRef: aws-cluster-identity-secret
      allowedNamespaces:
        selector:
          matchLabels: {}
    ```

3. Finally the `Credential` object needs to be created

    In the `identityRef:` section the `kind:` must be `AWSClusterStaticIdentity` and the `name:` must match of the `AWSClusterStaticIdentity` object.

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
        namespace: hmc-system
    ```

    > NOTE:
    > To use these newly created credentials the `Credential` object must be
    > created. It is described in detail in the [credential section](../credential/main.md).

## AWS AMI

By default AMI id will be looked up automatically using the latest Amazon Linux 2 image.

You can override lookup parameters to search your desired image automatically or
use AMI ID directly.
If both AMI ID and lookup parameters are defined AMI ID will have higher precedence.

### Image lookup

To configure automatic AMI lookup 3 parameters are used:

- `.imageLookup.format` - used directly as value for the `name` filter
(see the [describe-images filters](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html#describe-images)).
  - Supports substitutions for `{{.BaseOS}}` and `{{.K8sVersion}}` with the base OS
and kubernetes version, respectively.

- `.imageLookup.org` - AWS org ID which will be used as value for the `owner-id`
filter.

- `.imageLookup.baseOS` - will be used as value for `{{.BaseOS}}` substitution in
the `.imageLookup.format` string.

### AMI ID

AMI ID can be directly used in the `.amiID` parameter.

#### CAPA prebuilt AMIs

Use `clusterawsadm` to get available AMIs to deploy managed cluster:

```bash
clusterawsadm ami list
```

For details, see [Pre-built Kubernetes AMIs](https://cluster-api-aws.sigs.k8s.io/topics/images/built-amis.html).

## SSH access to cluster nodes

To access the nodes using the SSH protocol, several things should be configured:

- An SSH key added in the region where you want to deploy the cluster
- Bastion host is enabled

### SSH keys

Only one SSH key is supported and it should be added in AWS prior to creating
the `ManagedCluster` object. The name of the key should then be placed under `.spec.config.sshKeyName`.

The same SSH key will be used for all machines and a bastion host.

To enable bastion you should add `.spec.config.bastion.enabled` option in the
`ManagedCluster` object to `true`.

Full list of the bastion configuration options could be fould in [CAPA docs](https://cluster-api-aws.sigs.k8s.io/crd/#infrastructure.cluster.x-k8s.io/v1beta1.Bastion).

The resulting `ManagedCluster` can look like this:

```yaml
apiVersion: hmc.mirantis.com/v1alpha1
kind: ManagedCluster
metadata:
  name: cluster-1
spec:
  template: aws-standalone-cp
  credential: aws-cred
  config:
    sshKeyName: foobar
    bastion:
      enabled: true
...
```
