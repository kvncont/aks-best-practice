# Resource Group
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

# Network
output "vnet_id" {
  description = "ID of the virtual network"
  value       = var.create_vnet ? azurerm_virtual_network.main[0].id : null
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = var.create_vnet ? azurerm_virtual_network.main[0].name : local.vnet_name
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = var.create_vnet ? azurerm_subnet.aks[0].id : var.subnet_id
}

output "app_gateway_subnet_id" {
  description = "ID of the Application Gateway subnet"
  value       = var.create_vnet ? azurerm_subnet.app_gateway[0].id : null
}

# User Assigned Identity
output "identity_id" {
  description = "ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.main.id
}

output "identity_principal_id" {
  description = "Principal ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.main.principal_id
}

output "identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.main.client_id
}

# AKS
output "aks_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "aks_node_resource_group" {
  description = "Resource group for AKS nodes"
  value       = azurerm_kubernetes_cluster.main.node_resource_group
}

output "aks_kubelet_identity" {
  description = "Kubelet identity of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.kubelet_identity
}

output "aks_oidc_issuer_url" {
  description = "OIDC issuer URL of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

# ACR
output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = var.create_acr ? azurerm_container_registry.main[0].id : var.existing_acr_id
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = var.create_acr ? azurerm_container_registry.main[0].name : null
}

output "acr_login_server" {
  description = "Login server of the Azure Container Registry"
  value       = var.create_acr ? azurerm_container_registry.main[0].login_server : null
}

# Application Gateway
output "app_gateway_id" {
  description = "ID of the Application Gateway"
  value       = var.create_app_gateway ? azurerm_application_gateway.main[0].id : var.existing_app_gateway_id
}

output "app_gateway_name" {
  description = "Name of the Application Gateway"
  value       = var.create_app_gateway ? azurerm_application_gateway.main[0].name : null
}

output "app_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = var.create_app_gateway ? azurerm_public_ip.app_gateway[0].ip_address : null
}

# Log Analytics
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = var.enable_log_analytics ? azurerm_log_analytics_workspace.main[0].id : null
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = var.enable_log_analytics ? azurerm_log_analytics_workspace.main[0].name : null
}

# VNet Peering
output "vnet_peering_ids" {
  description = "IDs of VNet peerings created"
  value       = { for k, v in azurerm_virtual_network_peering.this : k => v.id }
}
