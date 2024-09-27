# Welcome to Mirantis Project 2A Docs


# Introduction

Mirantis Project 2A and is focused and developing a consistent way to deploy 
and manage kubernetes clusters at scale. More information can be found [here](./introduction.md) 

Project 2A was created to be a repeatable and secure way to leverage the tools 
developed as part of the kubernetes ecosystem e.g. Cluster API without modifying 
them, yet still being able to provide for the range of unique use cases we have 
come across within enterprise IT environments. 

## Main Premise

2A is built around the creation of a set of standardised templates that enable 
easy and repeatable cluster deployments and life cycle management. 

The main components of 2A include:

 * Hybrid Multi Cluster Management(HMC)
   
    Deployment and lifecycle managment of kubernetes clusters, including configuration, updates, and other CRUD operations.

 * Cluster State Management (SMC)

    Installation and lifecycle management of [beachead services](glossary.md#beach-head-services), policy, kubernetes api configurations and more.

 * Observability (OBS)

    Cluster and beach head services monitoring, events and log management.


## Supported Providers

HMC leverages the Cluster API provider ecosystem, the following providers have 
had templates created and validated, and more are in the works.


 * [AWS](./aws/main.md)
 * [Azure](./azure/main.md)
 * [Vsphere](./vsphere/main.md)




## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        