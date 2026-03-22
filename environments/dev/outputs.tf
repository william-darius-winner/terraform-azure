output "resource_group_name" {
  value = module.networking.resource_group_name
}

output "cluster_name" {
  value = module.aks.cluster_name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "kube_connect_command" {
  value = "az aks get-credentials --resource-group ${module.networking.resource_group_name} --name ${module.aks.cluster_name}"
}
