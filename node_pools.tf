resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = var.additional_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = each.value.vm_size
  vnet_subnet_id        = var.create_vnet ? azurerm_subnet.aks[0].id : var.subnet_id
  zones                 = each.value.zones
  max_pods              = each.value.max_pods
  os_disk_size_gb       = each.value.os_disk_size_gb
  auto_scaling_enabled  = each.value.enable_auto_scaling
  node_labels           = each.value.node_labels
  node_taints           = each.value.node_taints

  node_count = each.value.enable_auto_scaling ? null : each.value.node_count
  min_count  = each.value.enable_auto_scaling ? each.value.min_count : null
  max_count  = each.value.enable_auto_scaling ? each.value.max_count : null

  tags = var.tags
}
