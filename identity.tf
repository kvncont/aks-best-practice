locals {
  identity_name = var.identity_name != null ? var.identity_name : "${var.aks_name}-identity"
}

resource "azurerm_user_assigned_identity" "main" {
  name                = local.identity_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# Assign Network Contributor role to the identity on the subnet
resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.create_vnet ? azurerm_subnet.aks[0].id : var.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

# Assign AcrPull role to the identity on the ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

# Assign Managed Identity Operator role to AKS on the user-assigned identity
resource "azurerm_role_assignment" "managed_identity_operator" {
  scope                = azurerm_user_assigned_identity.main.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

# Assign Contributor role to the identity on the Application Gateway
resource "azurerm_role_assignment" "app_gateway_contributor" {
  scope                = azurerm_application_gateway.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

# Assign Reader role to the identity on the resource group
resource "azurerm_role_assignment" "reader" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}
