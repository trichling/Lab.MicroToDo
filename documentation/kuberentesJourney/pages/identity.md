# Identity

- Try to use managed identity everywhere, because it does not require any secrets that may get stale and require rotation

- Managed Identity can be **system assigned** or **user assigned**

- System assigned identity is created automatically when you create a resource, and deleted when it goes away

- User assigned identity is created separately and can be assigned to multiple resources, bu it is not deleted when resources are deleted

- You can use managed identity to authenticate to Azure services such as Key Vault, Storage, SQL, etc.

- Inside AKS you need to use workload identity to map managed identity to Kubernetes service account