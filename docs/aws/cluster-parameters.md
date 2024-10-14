# AWS cluster parameters

## Software prerequisites

1. `clusterawsadm` CLI installed locally.

## Cluster Identity

To provide credentials for CAPI AWS provider (CAPA) `ClusterIdentity` object
must be created.

AWS provider supports 3 types of `ClusterIdentity`, which one to use depends on
your specific use case. More information regarding CAPA `ClusterIdentity`
resources could be found in [CRD Reference](https://cluster-api-aws.sigs.k8s.io/crd/)

In this example we're using [`AWSClusterStaticIdentity`](https://cluster-api-aws.sigs.k8s.io/crd/#infrastructure.cluster.x-k8s.io/v1beta1.AWSClusterStaticIdentity).

To create `ClusterIdentity` IAM user must be created and assigned with the
following roles:

- `control-plane.cluster-api-provider-aws.sigs.k8s.io`
- `controllers.cluster-api-provider-aws.sigs.k8s.io`
- `nodes.cluster-api-provider-aws.sigs.k8s.io`

Follow the [IAM setup guide](cloudformation.md#aws-iam-setup) (if not already)
to create these roles.

Next the following secret should be created with the user's credentials:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: aws-cred-secret
  namespace: hmc-system
type: Opaque
stringData:
  AccessKeyID: "AAAEXAMPLE"
  SecretAccessKey: "++AQDEXAMPLE"
```

> NOTE:
> The secret must be created in the same `Namespace` where CAPA provider is
> running. In case of Project 2A it's currently `hmc-system`. Placing secret in
> any other `Namespace` will result controller not able to read it.

After the `Secret` was created the `AWSClusterStaticIdentity` must be create
like so:

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSClusterStaticIdentity
metadata:
  name: aws-cluster-identity
spec:
  secretRef: aws-cred-secret
```

To use these newly created credentials the `Credential` object must be
created. It is described in detail in the [credential section](../credential/main.md).

## AWS AMI

By default AMI id will be looked up automatically (latest Amazon Linux 2 image
will be used).

You can override lookup parameters to search your desired image automatically or
use AMI ID directly.
If both AMI ID and lookup parameters are defined AMI ID will have higher precedence.

### Image lookup

To configure automatic AMI lookup 3 parameters are used:

`.imageLookup.format` - used directly as value for the `name` filter
(see the [describe-images filters](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html#describe-images)).
Supports substitutions for `{{.BaseOS}}` and `{{.K8sVersion}}` with the base OS
and kubernetes version, respectively.

`.imageLookup.org` - AWS org ID which will be used as value for the `owner-id`
filter.

`.imageLookup.baseOS` - will be used as value for `{{.BaseOS}}` substitution in
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
