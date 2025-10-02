resource "azurerm_container_registry" "main" {
  name                          = var.acr_name
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  sku                           = var.acr_sku
  admin_enabled                 = false
  public_network_access_enabled = var.acr_public_network_access_enabled
  tags                          = var.tags

  network_rule_set {
    default_action = var.acr_public_network_access_enabled ? "Allow" : "Deny"
  }
}
