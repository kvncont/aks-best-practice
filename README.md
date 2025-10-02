# Terraform Azure AKS Module

This Terraform module creates a comprehensive Azure Kubernetes Service (AKS) infrastructure with best practices, including:

- Azure Kubernetes Service (AKS) cluster with Azure CNI Overlay
- Azure Container Registry (ACR) with private access
- Application Gateway for ingress controller
- User-assigned managed identity with required permissions
- Optional Log Analytics workspace and Container Insights
- Optional diagnostic settings
- Optional monitoring alerts
- Virtual Network and subnets (can be created or use existing)

## Features

- **Modular Design**: Organized by resource type for easy maintenance
- **Private Resources**: All resources are configured for private access by default
- **Flexible Networking**: Can create new VNet or use existing infrastructure
- **Azure CNI Overlay**: Uses Azure CNI Overlay for efficient IP address management
- **Application Gateway Ingress Controller**: Integrated AGIC for AKS
- **Auto-scaling**: Support for cluster autoscaling
- **Multiple Node Pools**: Support for default and additional node pools
- **Monitoring**: Optional Log Analytics, diagnostic settings, and alerts
- **Security**: User-assigned managed identity with least privilege permissions

## Prerequisites

- Terraform >= 1.11
- Azure subscription
- Azure CLI configured or Service Principal credentials

## Usage

### Complete Example

```hcl
module "aks" {
  source = "github.com/kvncont/aks-best-practice.git"

  # Resource Group
  resource_group_name = "rg-aks-example"
  location            = "eastus"

  # Network Configuration
  create_vnet              = true
  vnet_name                = "vnet-aks-example"
  vnet_address_space       = ["10.0.0.0/16"]
  subnet_name              = "subnet-aks"
  subnet_address_prefix    = "10.0.1.0/24"
  app_gateway_subnet_name  = "subnet-appgw"
  app_gateway_subnet_address_prefix = "10.0.2.0/24"

  # AKS Configuration
  aks_name               = "aks-example"
  aks_dns_prefix         = "aks-example"
  private_cluster_enabled = true

  # Default Node Pool
  default_node_pool_vm_size            = "Standard_D2s_v3"
  default_node_pool_enable_auto_scaling = true
  default_node_pool_min_count          = 2
  default_node_pool_max_count          = 5

  # Azure Container Registry
  acr_name = "acraksexample"

  # Application Gateway
  app_gateway_name = "appgw-aks-example"

  # Optional: Log Analytics
  enable_log_analytics = true

  # Optional: Diagnostic Settings
  enable_diagnostic_settings = true

  # Optional: Alerts
  enable_alerts = true
  alert_email_receivers = [
    {
      name          = "admin"
      email_address = "admin@example.com"
    }
  ]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

### Minimal Example

```hcl
module "aks" {
  source = "github.com/kvncont/aks-best-practice.git"

  resource_group_name = "rg-aks-minimal"
  location            = "eastus"

  create_vnet              = true
  vnet_name                = "vnet-aks-minimal"
  subnet_name              = "subnet-aks"
  app_gateway_subnet_name  = "subnet-appgw"

  aks_name               = "aks-minimal"
  aks_dns_prefix         = "aks-minimal"
  acr_name               = "acraksminimal"
  app_gateway_name       = "appgw-aks-minimal"

  enable_log_analytics       = false
  enable_diagnostic_settings = false
  enable_alerts              = false
}
```

### Using Existing VNet

```hcl
module "aks" {
  source = "github.com/kvncont/aks-best-practice.git"

  resource_group_name = "rg-aks-existing-vnet"
  location            = "eastus"

  create_vnet              = false
  vnet_name                = "existing-vnet"
  vnet_resource_group_name = "rg-network"
  subnet_name              = "existing-subnet"
  subnet_id                = "/subscriptions/.../subnets/existing-subnet"

  aks_name         = "aks-existing-vnet"
  aks_dns_prefix   = "aks-existing-vnet"
  acr_name         = "acraksexisting"
  app_gateway_name = "appgw-aks-existing"
}
```

## Module Structure

The module is organized into the following files:

- `main.tf` - Resource group creation
- `variables.tf` - Input variable definitions
- `outputs.tf` - Output value definitions
- `providers.tf` - Provider requirements
- `network.tf` - Virtual network and subnet resources
- `identity.tf` - User-assigned managed identity and role assignments
- `acr.tf` - Azure Container Registry
- `log_analytics.tf` - Log Analytics workspace and Container Insights
- `aks.tf` - AKS cluster configuration
- `node_pools.tf` - Additional node pools
- `application_gateway.tf` - Application Gateway
- `diagnostic_settings.tf` - Diagnostic settings for AKS
- `alerts.tf` - Monitoring alerts

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.11 |
| azurerm | ~> 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region where resources will be deployed | `string` | n/a | yes |
| aks_name | Name of the AKS cluster | `string` | n/a | yes |
| aks_dns_prefix | DNS prefix for the AKS cluster | `string` | n/a | yes |
| acr_name | Name of the Azure Container Registry | `string` | n/a | yes |
| app_gateway_name | Name of the Application Gateway | `string` | n/a | yes |
| create_vnet | Whether to create a new virtual network | `bool` | `true` | no |
| vnet_name | Name of the virtual network | `string` | `null` | no |
| private_cluster_enabled | Whether to enable private cluster mode | `bool` | `true` | no |
| enable_log_analytics | Enable Log Analytics workspace | `bool` | `true` | no |
| enable_diagnostic_settings | Enable diagnostic settings for AKS | `bool` | `true` | no |
| enable_alerts | Enable monitoring alerts | `bool` | `true` | no |

For a complete list of inputs, see [variables.tf](variables.tf).

## Outputs

| Name | Description |
|------|-------------|
| aks_id | ID of the AKS cluster |
| aks_name | Name of the AKS cluster |
| aks_fqdn | FQDN of the AKS cluster |
| acr_login_server | Login server of the Azure Container Registry |
| app_gateway_public_ip | Public IP address of the Application Gateway |
| identity_client_id | Client ID of the user-assigned managed identity |

For a complete list of outputs, see [outputs.tf](outputs.tf).

## Examples

- [Complete Example](examples/complete/) - Full configuration with all features enabled
- [Minimal Example](examples/minimal/) - Minimal configuration with optional features disabled

## Security Considerations

- All resources are configured for private access by default
- User-assigned managed identity is used instead of system-assigned identity
- Network Contributor role is assigned to the identity on the subnet
- AcrPull role is assigned to the identity on ACR
- ACR has public network access disabled by default
- AKS is configured as a private cluster by default

## License

This module is licensed under the MIT License.