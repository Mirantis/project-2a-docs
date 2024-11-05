# Welcome to Mirantis Project 0x2A Docs

## Introduction

Mirantis Project 0x2A is focused on developing a consistent way to deploy 
and manage Kubernetes clusters at scale.

Project 0x2A was created to be a repeatable and secure way to leverage the existing
Kubernetes ecosystem (e.g. Cluster API) while being able to provide for the range of
unique use cases that exist within enterprise IT environments. 

## Main Premise

0x2A is built around the creation of a set of standardised templates that enable 
easy, repeatable cluster deployments and life cycle management. 

The main components of 0x2A include:

 * Hybrid Multi Cluster Management (HMC)

    Deployment and lifecycle managment of Kubernetes clusters, including configuration, updates, and other CRUD operations.

 * Cluster State Management (SMC)

    Installation and lifecycle management of [beach-head services](glossary.md#beach-head-services), policy, Kubernetes api configurations and more.

 * Observability (OBS)

    Cluster and beach-head services monitoring, events and log management.

## Quick Start

See the [0x2A Quick Start Guide](quick-start/2a-installation.md)

## Supported Providers

HMC leverages the Cluster API provider ecosystem, the following providers have
had ProviderTemplates created and validated, and more are in the works.

 * [AWS](quick-start/aws.md)
 * [Azure](quick-start/azure.md)
 * [vSphere](quick-start/vsphere.md)

## Development documentation

Documentation releated to development process and dev-specific notes located in
the [main repository](https://github.com/Mirantis/hmc/blob/main/docs/dev.md).
