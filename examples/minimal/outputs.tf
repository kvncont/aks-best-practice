output "aks_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.aks_name
}

output "acr_login_server" {
  description = "Login server of the Azure Container Registry"
  value       = module.aks.acr_login_server
}
