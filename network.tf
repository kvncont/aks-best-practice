resource "azurerm_virtual_network" "main" {
  count               = var.create_vnet ? 1 : 0
  name                = var.vnet_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "aks" {
  count                = var.create_vnet ? 1 : 0
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.subnet_address_prefix]
}

resource "azurerm_subnet" "app_gateway" {
  count                = var.create_vnet ? 1 : 0
  name                 = var.app_gateway_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.app_gateway_subnet_address_prefix]
}
