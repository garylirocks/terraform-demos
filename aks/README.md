# AKS

Create a AKS cluster for testing, and monitoring resources.


```sh
# get K8s credentials
az aks get-credentials --name aks-demo-001 --resource-group rg-aks-demo-001

# now you could connect to it using kubectl
kubectl get nodes
```

See here on how to enable Prometheus and Grafana: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-enable

- Tried the Azure Policy, but the deployment failed, haven't investigated the cause
- The CLI method worked
- A default DCR and DCE are created with the Azure Monitor workspace, new DCR and DCE will be created for the managed Prometheus addon