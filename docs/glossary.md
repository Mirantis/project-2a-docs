# Glossary

This glossary is a collection of terms related to Project 2A. In it we
attempt to clarify some of the unique terms and concepts we use or explain
more common ones that we feel may need a little clarity in the way we use
them. 

### Beach-head Services
We use the term to refer to those Kubernetes services that need to be installed
on a Kubernetes cluster to make it actually useful, for example: an ingress controller,
CNI and/or CSI. Whilst from the perspective of how they are deployed they are no different
from other Kubernetes services we define them as distinct from the apps and services
deployed as part of the applications.

### Cloud Controller Manager
Cloud Controller Manager (CCM) is a Kubernetes component that embeds logic to
manage a specific infrastructure provider.

### ClusterIdentity
ClusterIdentity is a Kubernetes object that references a Secret object
containing credentials for a specific infrastructure provider.

### Credential
A `Credential` is a custom resource (CR) in HMC that supplies 2A with the
necessary credentials to manage a specific infrastructure. The credential object
references other CRs with infrastructure-specific credentials such as access
keys, passwords, certificates, etc. This means that a credential is specific to
the CAPI provider that uses it.

### Infrastructure provider (see also [CAPI provider](#capi-provider-see-also-infrastructure-provider))
An infrastructure provider (aka `InfrastructureProvider`) is a Kubernetes custom
resource (CR) that defines the infrastructure-specific configuration needed for
managing Kubernetes clusters. It enables Cluster API (CAPI) to provision and
manage clusters on a specific infrastructure platform (e.g., AWS, Azure, VMware,
OpenStack, etc.).

### Managed Cluster
A Kubernetes cluster created and managed by Project 0x2A.

### Management Cluster
The Kubernetes cluster where 0x2A is installed and from which all other managed clusters will
be managed from.

### Provider (also Infrastructure Provider)
A Kubernetes cluster provider is a Kubernetes API extension that allows 0x2A to manage
clusters on a specific infrastructure.
