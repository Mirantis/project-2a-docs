# Prepare the EKS infra provider

## Software prerequisites

1. `kubectl`: CLI installed locally.
2. `AWS`: Ensure you have the [AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and configured with the necessary IAM permissions.
3. `eksctl`: Install eksctl by following the official guide.

## Configure AWS IAM

Follow the AWS IAM [setup quide](../aws/cloudformation.md#aws-iam-setup).

## AWS cluster parameters

Follow the [AWS Cluster Parameters guide](../aws/cluster-parameters.md#aws-cluster-parameters)

## EKS cluster creation

`export DEV_PROVIDER=eks` variable are essential for EKS cluster creation with Project 2A

## Verify the Cluster

After the creation process completes, verify that your EKS cluster is running:

`eksctl get cluster --region us-east-2`

You should see your cluster listed with the status ACTIVE.

## Update kubeconfig

Ensure that your kubeconfig is updated to connect to the new cluster:

`aws eks --region us-east-2 update-kubeconfig --name my-eks-cluster`

This allows kubectl to communicate with your EKS cluster.

## Test the Cluster

Run a command to see if you can interact with the cluster:

`kubectl get nodes`

You should see the list of nodes in your EKS cluster.
