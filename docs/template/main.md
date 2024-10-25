# Templates system

By default, 2A delivers a set of default `ProviderTemplate`, `ClusterTemplate` and `SystemTemplate` objects:

* `ProviderTemplate`
   The template containing the configuration of the provider, ex. k0smotron. Cluster-scoped.
* `ClusterTemplate`
   The template containing the configuration of the cluster objects. Namespace-scoped.
* `ServiceTemplate`
   The template containing the configuration of the service to be installed on the managed cluster. Namespace-scoped.

All Templates are immutable. You can also build your own templates and use them for deployment along with the
Templates shipped with 2A.

## Bring your own Templates

Here are the instructions on how to bring your own Template to HMC:

1. Create a [HelmRepository](https://fluxcd.io/flux/components/source/helmrepositories/) object containing the URL to the
external Helm repository. Label it with `hmc.mirantis.com/managed: "true"`.
2. Create a [HelmChart](https://fluxcd.io/flux/components/source/helmcharts/) object referencing the `HelmRepository` as a
`sourceRef`, specifying the name and version of your Helm chart. Label it with `hmc.mirantis.com/managed: "true"`.
3. Create a `ClusterTemplate`, `ServiceTemplate` or `ProviderTemplate` object referencing this helm chart in
`spec.helm.chartRef`. `chartRef` is a field of the
[CrossNamespaceSourceReference](https://fluxcd.io/flux/components/helm/api/v2/#helm.toolkit.fluxcd.io/v2.CrossNamespaceSourceReference) kind.
For `ClusterTemplate` and `ServiceTemplate` configure the namespace where this template should reside
(`metadata.namespace`).

> NOTE:
> `ClusterTemplate` and `ServiceTemplate` objects should reside in the same namespace as the `ManagedCluster`
> referencing them. The `ManagedCluster` can't reference the Template from another namespace (the creation request will
> be declined by the admission webhook). All `ClusterTemplates` and `ServiceTemplates` shipped with HMC reside in the
> system namespace (defaults to `hmc-system`). To get the instructions on how to distribute Templates along multiple
> namespaces, read [Template Life Cycle Management](template-management.md#template-life-cycle-management).

Here is an example of a custom `ClusterTemplate` with the `HelmChart` reference:

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: custom-templates-repo
  namespace: hmc-system
  labels:
    hmc.mirantis.com/managed: "true"
spec:
  insecure: true
  interval: 10m0s
  provider: generic
  type: oci
  url: oci://ghcr.io/external-templates-repo/charts
```

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmChart
metadata:
  name: custom-template-chart
  namespace: hmc-system
  labels:
    hmc.mirantis.com/managed: "true"
spec:
  interval: 5m0s
  chart: custom-template-chart-name
  reconcileStrategy: ChartVersion
  sourceRef:
    kind: HelmRepository
    name: custom-templates-repo
  version: 0.2.0
```

```yaml
apiVersion: hmc.mirantis.com/v1alpha1
kind: ClusterTemplate
metadata:
  name: os-k0smotron
  namespace: hmc-system
spec:
  type: deployment
  providers:
    infrastructure:
      - openstack
    bootstrap:
      - k0s
    controlPlane:
      - k0smotron
  helm:
    chartRef:
      kind: HelmChart
      name: custom-template-chart
      namespace: default
```

The `*Template` should follow the rules mentioned below:

`spec.providers` should contain the list of required Cluster API providers: `infrastructure`, `bootstrap` and
`control-plane`. As an alternative, the referenced helm chart may contain the specific annotations in the `Chart.yaml`
(value is a list of providers divided by comma). These fields are only used for validation. For example:

`ClusterTemplate` spec:

```yaml
spec:
  providers:
  - bootstrap-k0smotron
  - control-plane-k0smotron
  - infrastructure-aws
```

`Chart.yaml`:

```bash
annotations:
  cluster.x-k8s.io/provider: infrastructure-aws, control-plane-k0smotron, bootstrap-k0smotron
```

## Compatibility attributes

Each of the `*Template` resources has compatibility versions attributes to constraint the core `CAPI`, `CAPI` provider or Kubernetes versions.
CAPI-related version constraints must be set in the [`CAPI` contract format](https://cluster-api.sigs.k8s.io/developer/providers/contracts).
Kubernetes version constraints must be set in the Semantic Version format.
Each attribute can be set either via the corresponding `.spec` fields or via the annotations.
Values set via the `.spec` have precedence over the values set via the annotations.

> NOTE:
> All of the compatibility attributes are optional, and validation checks only take place
> if **both** of the corresponding type attributes
> (e.g. provider contract versions in both `ProviderTemplate` and `ClusterTemplate`) are set.

1. The `ProviderTemplate` resource has dedicated fields to set compatible `CAPI` contract versions along
with CRDs contract versions supported by the provider.
Given contract versions will be then set accordingly in the `.status` field.
Compatibility contract versions are key-value pairs, where the key is **the core `CAPI` contract version**,
and the value is an underscore-delimited (_) list of provider contract versions supported by the core `CAPI`.
For the core `CAPI` Template values should be empty.

    Example with the `.spec`:

    ```yaml
    apiVersion: hmc.mirantis.com/v1alpha1
    kind: ProviderTemplate
    # ...
    spec:
      providers:
      - infrastructure-aws
      capiContracts:
        # commented is the example exclusively for the core CAPI Template
        # v1alpha3: ""
        # v1alpha4: ""
        # v1beta1: ""
        v1alpha3: v1alpha3
        v1alpha4: v1alpha4
        v1beta1: v1beta1_v1beta2
    ```

    Example with the `annotations` in the `Chart.yaml` with the same logic
    as in the `.spec`:

    ```yaml
    annotations:
      cluster.x-k8s.io/provider: infrastructure-aws
      cluster.x-k8s.io/v1alpha3: v1alpha3
      cluster.x-k8s.io/v1alpha4: v1alpha4
      cluster.x-k8s.io/v1beta1: v1beta1_v1beta2
    ```

1. The `ClusterTemplate` resource has dedicated fields to set an exact compatible Kubernetes version
in the Semantic Version format and required contract versions per each provider to match against
the related `ProviderTemplate` objects.
Given compatibility attributes will be then set accordingly in the `.status` field.
Compatibility contract versions are key-value pairs, where the key is **the name of the provider**,
and the value is the provider contract version required to be supported by the provider.

    Example with the `spec`:

    ```yaml
    apiVersion: hmc.mirantis.com/v1alpha1
    kind: ClusterTemplate
    # ...
    spec:
      k8sVersion: 1.30.0 # only exact semantic version is applicable
      providers:
      - bootstrap-k0smotron
      - control-plane-k0smotron
      - infrastructure-aws
      providerContracts:
        bootstrap-k0smotron: v1beta1 # only a single contract version is applicable
        control-plane-k0smotron: v1beta1
        infrastructure-aws: v1beta2
    ```

    Example with the `annotations` in the `Chart.yaml`:

    ```yaml
    annotations:
      cluster.x-k8s.io/provider: infrastructure-aws, control-plane-k0smotron, bootstrap-k0smotron
      cluster.x-k8s.io/bootstrap-k0smotron: v1beta1
      cluster.x-k8s.io/control-plane-k0smotron: v1beta1
      cluster.x-k8s.io/infrastructure-aws: v1beta2
      hmc.mirantis.com/k8s-version: 1.30.0
    ```

1. The `ServiceTemplate` resource has dedicated fields to set an compatibility constrained
Kubernetes version to match against the related `ClusterTemplate` objects.
Given compatibility values will be then set accordingly in the `.status` field.

    Example with the `spec`:

    ```yaml
    apiVersion: hmc.mirantis.com/v1alpha1
    kind: ServiceTemplate
    # ...
    spec:
      k8sConstraint: "^1.30.0" # only semantic version constraints are applicable
    ```

    Example with the `annotations` in the `Chart.yaml`:

    ```yaml
    hmc.mirantis.com/k8s-version-constraint: ^1.30.0
    ```

### Compatibility attributes enforcement

The aforedescribed attributes are being checked sticking to the following rules:

* both the exact and constraint version of the same type (e.g. `k8sVersion` and `k8sConstraint`) must
be set otherwise no check is performed;
* if a `ProviderTemplate` object's exact providers versions do not satisfy the providers' versions
constraints from the related `ClusterTemplate` object, the updates to the `ManagedCluster` object will be blocked;
* if the core `CAPI` `ProviderTemplate` exact `CAPI` version does no satisfy the `CAPI` version
constraints from other of `ProviderTemplate` objects, the to the `Management` object will be blocked;
* if a `ClusterTemplate` object's exact kubernetes version does not satisfy the kubernetes version
constraint from the related `ServiceTemplate` object, the updates to the `ManagedCluster` object will be blocked.

## Remove Templates shipped with HMC

If you need to limit the templates that exist in your HMC installation, follow the instructions below:

1. Get the list of `ProviderTemplates`, `ClusterTemplates` or `ServiceTemplates` shipped with HMC. For example,
for `ClusterTemplate` objects, run:

    ```bash
    kubectl get clustertemplates -n hmc-system -l helm.toolkit.fluxcd.io/name=hmc-templates
    ```

    Example output:

    ```bash
    NAME                       VALID
    aws-hosted-cp              true
    aws-standalone-cp          true
    ```

2. Remove the template from the list using `kubectl delete`. For example:

    ```bash
    kubectl delete clustertemplate -n hmc-system <template-name>
    ```
