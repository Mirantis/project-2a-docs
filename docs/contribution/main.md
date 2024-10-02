## Introduction
We use MkDocs with the Mermaid plugin to publish our documentation to SITE_NAME. This guide will walk you through the process of configuring and deploying newly added documentation to our website.

## Publishing Documentation
The documentation source code is stored in our Git repository and updates are automatically handled through GitHub Actions. To publish updates to the documentation, follow these steps:

1. Fork the repository to your local environment.

2. Update the documentation with your changes and push them to your forked repository.

3. Create a pull request (PR) with your updates.

4. Once the PR is reviewed and approved, GitHub Actions will automatically publish the updated documentation.

## Setting Up a Local Docker Environment
To set up a local environment for updating the documentation, first fork the repository into your workspace. Then, follow the instructions in the  [Docker Guide](./docker.md) to install and configure Docker locally.