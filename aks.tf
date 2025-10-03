resource "azurerm_kubernetes_cluster" "main" {
  name                      = local.aks_name
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name
  dns_prefix                = local.aks_dns_prefix
  kubernetes_version        = var.kubernetes_version
  private_cluster_enabled   = var.private_cluster_enabled
  sku_tier                  = var.sku_tier
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  tags                      = var.tags

  default_node_pool {
    name                 = var.default_node_pool_name
    vm_size              = var.default_node_pool_vm_size
    vnet_subnet_id       = var.create_vnet ? azurerm_subnet.aks[0].id : var.subnet_id
    zones                = var.default_node_pool_zones
    max_pods             = var.default_node_pool_max_pods
    os_disk_size_gb      = var.default_node_pool_os_disk_size_gb
    auto_scaling_enabled = var.default_node_pool_enable_auto_scaling

    node_count = var.default_node_pool_enable_auto_scaling ? null : var.default_node_pool_node_count
    min_count  = var.default_node_pool_enable_auto_scaling ? var.default_node_pool_min_count : null
    max_count  = var.default_node_pool_enable_auto_scaling ? var.default_node_pool_max_count : null
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }

  network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin_mode
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
  }

  dynamic "oms_agent" {
    for_each = var.enable_log_analytics ? [1] : []
    content {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id
    }
  }

  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.main.id
  }

  depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_role_assignment.acr_pull,
    azurerm_application_gateway.main
  ]
}
