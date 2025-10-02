locals {
  action_group_name = var.action_group_name != null ? var.action_group_name : "${var.aks_name}-action-group"
}

resource "azurerm_monitor_action_group" "main" {
  count               = var.enable_alerts && length(var.alert_email_receivers) > 0 ? 1 : 0
  name                = local.action_group_name
  resource_group_name = azurerm_resource_group.main.name
  short_name          = var.action_group_short_name
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.alert_email_receivers
    content {
      name          = email_receiver.value.name
      email_address = email_receiver.value.email_address
    }
  }
}

# Alert for node CPU usage
resource "azurerm_monitor_metric_alert" "node_cpu" {
  count               = var.enable_alerts && length(var.alert_email_receivers) > 0 ? 1 : 0
  name                = "${var.aks_name}-node-cpu-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_kubernetes_cluster.main.id]
  description         = "Alert when node CPU usage exceeds 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }
}

# Alert for node memory usage
resource "azurerm_monitor_metric_alert" "node_memory" {
  count               = var.enable_alerts && length(var.alert_email_receivers) > 0 ? 1 : 0
  name                = "${var.aks_name}-node-memory-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_kubernetes_cluster.main.id]
  description         = "Alert when node memory usage exceeds 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_memory_working_set_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }
}

# Alert for pod count
resource "azurerm_monitor_metric_alert" "pod_count" {
  count               = var.enable_alerts && length(var.alert_email_receivers) > 0 ? 1 : 0
  name                = "${var.aks_name}-pod-count-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_kubernetes_cluster.main.id]
  description         = "Alert when pod count exceeds 80% of capacity"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "kube_pod_status_ready"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.default_node_pool_max_pods * var.default_node_pool_node_count * 0.8
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }
}

# Alert for disk usage
resource "azurerm_monitor_metric_alert" "disk_usage" {
  count               = var.enable_alerts && length(var.alert_email_receivers) > 0 ? 1 : 0
  name                = "${var.aks_name}-disk-usage-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_kubernetes_cluster.main.id]
  description         = "Alert when disk usage exceeds 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_disk_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }
}
