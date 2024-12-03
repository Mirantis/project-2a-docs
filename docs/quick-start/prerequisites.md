## Requirements

Project 2A requires a Kubernetes cluster. It can be of any type and will serve as the 2A _management cluster_.

If you don't yet have a Kubernetes cluster, consider using [k0s](https://docs.k0sproject.io/stable/install/).

The following instructions assume:

- Your `kubeconfig` points to the correct Kubernetes cluster.
- You have [Helm](https://helm.sh/docs/intro/install/) installed.
- You have [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) installed.

### Prerequisites

Before starting, make sure to meet the following prerequisites for compatibility with Project 2A components:

1. Kubernetes Version:
    - The minimum supported Kubernetes version for Project 2A is 1.28.0.
    - Using an older version (e.g., v1.26.2) will cause issues with some components, such as Flux, which require at least v1.28.0.
    - For best results, confirm your cluster is running Kubernetes v1.28.0 or later.

2. Cert-Manager Configuration:

    When installing the Helm chart, note that cert-manager will be installed automatically.
    - If cert-manager already exists in your cluster, the installation may fail due to conflicting metadata labels and annotations.
    To prevent this, ensure the existing cert-manager resources have the necessary metadata labels and annotations:
        - Labels: app.kubernetes.io/managed-by set to "Helm"
        - Annotations:
            - meta.helm.sh/release-name set to "hmc"
            - meta.helm.sh/release-namespace set to "hmc-system"
    - Adjusting this metadata should allow for compatibility with the installation.

### Helpful Tools

It is helpful to have the following tools installed:

- [clusterctl](https://cluster-api.sigs.k8s.io/user/quick-start.html?highlight=clusterctl#install-clusterctl) is the CLI for talking to ClusterAPI directly.
- [Mirantis Lens](https://k8slens.dev/) or [k9s](https://k9scli.io/) can be used for simplified management of Kubernetes objects. 