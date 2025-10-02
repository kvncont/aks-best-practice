# AKS Cluster Outputs
output "aks_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.aks_id
}

output "aks_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.aks_name
}

output "aks_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks.aks_fqdn
}

# ACR Outputs
output "acr_login_server" {
  description = "Login server of the Azure Container Registry"
  value       = module.aks.acr_login_server
}

# Application Gateway Outputs
output "app_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = module.aks.app_gateway_public_ip
}

# Identity Outputs
output "identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = module.aks.identity_client_id
}
