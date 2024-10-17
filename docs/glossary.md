# Glossary

This glossary is a collection of terms related to Project 0x2A. In it we
attempt to clarify some of the unique terms and concepts we use or explain
more common ones that we feel may need a little clarity in the way we use
them.

### Management Cluster
The Kubernetes cluster where 0x2A is installed and from which all other managed clusters will
be managed from.

### Managed Cluster
Cluster created and managed by 0x2A.

### Beach-head Services
We use the term to refer to those Kubernetes services that need to be installed
on a Kubernetes cluster to make it actually useful, for example: an ingress controller,
CNI and/or CSI. Whilst from the perspective of how they are deployed they are no different
from other Kubernetes services we define them as distinct from the apps and services
deployed as part of the applications.
