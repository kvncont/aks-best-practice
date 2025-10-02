resource "azurerm_monitor_diagnostic_setting" "aks" {
  count                      = var.enable_diagnostic_settings && var.enable_log_analytics ? 1 : 0
  name                       = var.diagnostic_setting_name
  target_resource_id         = azurerm_kubernetes_cluster.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id

  dynamic "enabled_log" {
    for_each = var.diagnostic_logs
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.diagnostic_metrics
    content {
      category = metric.value
      enabled  = true
    }
  }
}
