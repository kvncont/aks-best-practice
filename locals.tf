locals {
  # Base naming pattern
  base_name = "${var.owner}-${var.name}-${var.env}"

  # Resource names with appropriate prefixes
  resource_group_name          = var.resource_group_name != null ? var.resource_group_name : "rg-${local.base_name}"
  aks_name                     = var.aks_name != null ? var.aks_name : "aks-${local.base_name}"
  aks_dns_prefix               = var.aks_dns_prefix != null ? var.aks_dns_prefix : local.base_name
  acr_name                     = var.acr_name != null ? var.acr_name : "acr${replace(local.base_name, "-", "")}"
  app_gateway_name             = var.app_gateway_name != null ? var.app_gateway_name : "agw-${local.base_name}"
  vnet_name                    = var.vnet_name != null ? var.vnet_name : "vnet-${local.base_name}"
  identity_name                = var.identity_name != null ? var.identity_name : "uai-${local.base_name}"
  log_analytics_workspace_name = var.log_analytics_workspace_name != null ? var.log_analytics_workspace_name : "log-${local.base_name}"
  action_group_name            = var.action_group_name != null ? var.action_group_name : "ag-${local.base_name}"
}
