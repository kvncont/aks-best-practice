resource "azurerm_virtual_network" "main" {
  count               = var.create_vnet ? 1 : 0
  name                = local.vnet_name
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

# Additional subnets for node pools
resource "azurerm_subnet" "node_pool" {
  for_each = {
    for name, pool in var.additional_node_pools : name => pool
    if var.create_vnet && pool.create_subnet && pool.subnet_address_prefix != null
  }

  name                 = "subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [each.value.subnet_address_prefix]
}
