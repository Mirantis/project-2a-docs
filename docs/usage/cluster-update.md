# Managed Cluster update

To update the `ManagedCluster` update `spec.template` in the `ManagedCluster` object to the new `ClusterTemplate` name:

Run:

```bash
kubectl patch managedcluster.hmc <Your Cluster Name> -n <Namespace> --patch '{"spec":{"template":"<new-template-name>"}}' --type=merge
```

Then, check the status of the `ManagedCluster` object:

```bash
kubectl get managedcluster.hmc <Your Cluster Name> -n <Namespace>
```

In the commands above, replace the parameters enclosed in angle brackets with
the corresponding values.

To get more details, run the previous command with `-o=yaml` option and check
the `status.conditions`.

!!! note
    The `ManagedCluster` is allowed to be updated to the specific templates
    only. The templates available for the update are defined in the
    `ClusterTemplateChain` objects. Also, the `TemplateManagement` object should
    contain properly configured `spec.accessRules` with the list of
    `ClusterTemplateChain` object names and the namespaces where the supported
    templates from the chain spec will be delivered. For details, see:
    [Template Life Cycle Management](../template/main.md/#template-life-cycle-management).

<!---
TODO: Later all `ClusterTemplates` that are available for the update will be shown in the `ManagedCluster` status.
-->
