# ARM template deployment

This demo creates a resource group via an ARM template deployment.
- To test KV secret referencing, it uses a KV secret as tag value

A few things to note:

- If you delete the deployment resource, rerun will re-create the deployment resource, and the end resources if needed.
- If you delete the end resources, but not the deployment resource itself, rerun would not re-create the end resources.
- If a parameter references a KV secret, you should add `secretVersion` as well, otherwise, given the deployment resource is still there, rerun would not retrieve the latest secret value and update the end resources.
