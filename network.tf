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

# Data source to get external VNet information when using external subnets
locals {
  # Collect all external subnet IDs that need peering
  external_subnet_ids = compact(concat(
    [!var.create_vnet && var.subnet_id != null ? var.subnet_id : null],
    [for name, pool in var.additional_node_pools : pool.subnet_id if pool.subnet_id != null]
  ))

  # Extract VNet IDs from subnet IDs
  # Subnet ID format: /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/virtualNetworks/{vnet}/subnets/{subnet}
  external_vnet_ids = distinct([
    for subnet_id in local.external_subnet_ids :
    join("/", slice(split("/", subnet_id), 0, 9))
  ])

  # Create a map for peering with unique names
  peering_vnets = var.create_vnet && var.enable_vnet_peering ? {
    for idx, vnet_id in local.external_vnet_ids :
    "peer-to-external-${idx}" => vnet_id
  } : {}
}

# VNet Peering from our VNet to external VNets
resource "azurerm_virtual_network_peering" "to_external" {
  for_each = local.peering_vnets

  name                      = each.key
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.main[0].name
  remote_virtual_network_id = each.value

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}
