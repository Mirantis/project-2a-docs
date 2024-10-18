# AWS infrastructure provider

The AWS Infrastructure provider within 2A provides for several deployment 
options these include:

Current:

- Colocated Control Plane and Worker
- Hosted Control Plane

Planned or in Progress:

- EKS Deployments

Prior to being able to deploy a cluster to AWS you need to setup the 
AWS IAM policies and prepare the cluster credentials. 

##  Prerequisites

1. Adminstrative user in AWS with right to create IAM users and policies
2. `kubectl` CLI installed locally
3. `clusterawsadm` CLI installed locally

## Configure AWS IAM 

Start here and follow the AWS IAM [setup guide](cloudformation.md#aws-iam-setup).

## AWS cluster parameters

To configure more cluster parameters follow the [AWS Cluster Parameters guide](cluster-parameters.md#aws-cluster-parameters).
