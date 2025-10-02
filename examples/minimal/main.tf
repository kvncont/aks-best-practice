module "aks" {
  source = "../../"

  # Resource Group
  resource_group_name = "rg-aks-minimal"
  location            = "eastus"

  # Network Configuration - Create new VNet
  create_vnet                       = true
  vnet_name                         = "vnet-aks-minimal"
  vnet_address_space                = ["10.0.0.0/16"]
  subnet_name                       = "subnet-aks"
  subnet_address_prefix             = "10.0.1.0/24"
  app_gateway_subnet_name           = "subnet-appgw"
  app_gateway_subnet_address_prefix = "10.0.2.0/24"

  # AKS Configuration
  aks_name                = "aks-minimal"
  aks_dns_prefix          = "aks-minimal"
  private_cluster_enabled = true

  # Default Node Pool
  default_node_pool_vm_size    = "Standard_D2s_v3"
  default_node_pool_node_count = 2

  # Azure Container Registry
  acr_name = "acraksminimal"

  # Application Gateway
  app_gateway_name = "appgw-aks-minimal"

  # Disable optional features
  enable_log_analytics       = false
  enable_diagnostic_settings = false
  enable_alerts              = false

  # Tags
  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
