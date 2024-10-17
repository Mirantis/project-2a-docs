# Glossary

This glossary is a collection of terms related to Project 0x2A. In it we
attempt to clarify some of the unique terms and concepts we use or explain
more common ones that we feel may need a little clarity in the way we use
them. 

### Beach-head Services
We use the term to refer to those kubernetes services that need to be installed
on a kubernetes cluster to make it actually useful, for example: an ingress controller, 
CNI and/or CSI. Whilst from the perspective of how they are deployed they are no different
from other Kubernetes services we define them as distinct from the apps and services 
deployed as part of the applications.

