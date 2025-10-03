module "aks" {
  source = "../../"

  # Naming Configuration
  owner = "myteam"
  name  = "example"
  env   = "prod"

  # Location
  location = "eastus"

  # Network Configuration - Create new VNet
  create_vnet                       = true
  vnet_address_space                = ["10.0.0.0/16"]
  subnet_name                       = "subnet-aks"
  subnet_address_prefix             = "10.0.1.0/24"
  app_gateway_subnet_name           = "subnet-appgw"
  app_gateway_subnet_address_prefix = "10.0.2.0/24"

  # AKS Configuration
  kubernetes_version      = "1.28"
  private_cluster_enabled = true
  sku_tier                = "Standard"

  # Default Node Pool
  default_node_pool_name                = "default"
  default_node_pool_vm_size             = "Standard_D2s_v3"
  default_node_pool_enable_auto_scaling = true
  default_node_pool_min_count           = 2
  default_node_pool_max_count           = 5
  default_node_pool_max_pods            = 30
  default_node_pool_os_disk_size_gb     = 128
  default_node_pool_zones               = ["1", "2", "3"]

  # Additional Node Pools
  additional_node_pools = {
    workload = {
      vm_size             = "Standard_D4s_v3"
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 3
      max_pods            = 30
      os_disk_size_gb     = 128
      zones               = ["1", "2", "3"]
      node_labels = {
        workload = "general"
      }
    }
  }

  # Network Profile
  network_plugin      = "azure"
  network_plugin_mode = "overlay"
  pod_cidr            = "10.244.0.0/16"
  service_cidr        = "10.245.0.0/16"
  dns_service_ip      = "10.245.0.10"

  # Azure Container Registry
  acr_sku                           = "Premium"
  acr_public_network_access_enabled = false

  # Application Gateway
  app_gateway_sku      = "Standard_v2"
  app_gateway_capacity = 2

  # Log Analytics
  enable_log_analytics         = true
  log_analytics_sku            = "PerGB2018"
  log_analytics_retention_days = 30

  # Diagnostic Settings
  enable_diagnostic_settings = true
  diagnostic_setting_name    = "aks-diagnostics"
  diagnostic_logs = [
    "kube-apiserver",
    "kube-controller-manager",
    "kube-scheduler",
    "kube-audit",
    "cluster-autoscaler"
  ]
  diagnostic_metrics = ["AllMetrics"]

  # Alerts
  enable_alerts           = true
  action_group_short_name = "aksalerts"
  alert_email_receivers = [
    {
      name          = "admin"
      email_address = "admin@example.com"
    }
  ]

  # Tags
  tags = {
    Environment = "Production"
    Project     = "AKS Example"
    ManagedBy   = "Terraform"
  }
}
