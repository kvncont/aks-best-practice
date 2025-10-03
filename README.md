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

The module uses a consistent naming convention for all resources: `{prefix}-{owner}-{name}-{env}`, where:
- `prefix`: Resource-specific prefix (e.g., `aks`, `acr`, `rg`, `vnet`, `agw`, `log`, `uai`, `ag`)
- `owner`: Owner or team name
- `name`: Base name for the application/workload
- `env`: Environment (e.g., dev, prod, staging)

All resource names are optional. If not provided, they will be automatically generated using this pattern.

### Complete Example

```hcl
module "aks" {
  source = "github.com/kvncont/aks-best-practice.git"

  # Naming Configuration (required)
  owner = "myteam"
  name  = "webapp"
  env   = "prod"

  # Location
  location = "eastus"

  # Network Configuration
  create_vnet        = true
  vnet_address_space = ["10.0.0.0/16"]

  # Default Node Pool
  default_node_pool_vm_size             = "Standard_D2s_v3"
  default_node_pool_enable_auto_scaling = true
  default_node_pool_min_count           = 2
  default_node_pool_max_count           = 5

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

  # Naming Configuration
  owner = "myteam"
  name  = "app"
  env   = "dev"

  # Location
  location = "eastus"

  # Disable optional features
  enable_log_analytics       = false
  enable_diagnostic_settings = false
  enable_alerts              = false
}
```

### Custom Resource Names

You can override any resource name while still using the naming convention for others:

```hcl
module "aks" {
  source = "github.com/kvncont/aks-best-practice.git"

  # Naming Configuration
  owner = "myteam"
  name  = "app"
  env   = "prod"

  # Location
  location = "eastus"

  # Custom names (optional)
  aks_name         = "my-custom-aks-name"
  acr_name         = "mycustomacrname"  # ACR names must be alphanumeric
  app_gateway_name = "my-custom-gateway"
}
```

### Using Existing VNet

```hcl
module "aks" {
  source = "github.com/kvncont/aks-best-practice.git"

  # Naming Configuration
  owner = "myteam"
  name  = "app"
  env   = "prod"

  # Location
  location = "eastus"

  # Use existing VNet
  create_vnet = false
  subnet_id   = "/subscriptions/.../subnets/existing-subnet"
}
```

### Node Pools with Dedicated Subnets

Each additional node pool can have its own dedicated subnet within the VNet:

```hcl
module "aks" {
  source = "github.com/kvncont/aks-best-practice.git"

  owner = "myteam"
  name  = "app"
  env   = "prod"
  location = "eastus"

  # Create VNet with larger address space
  create_vnet        = true
  vnet_address_space = ["10.0.0.0/16"]

  # Additional node pools with dedicated subnets
  additional_node_pools = {
    # This pool will use the same subnet as default node pool
    system2 = {
      vm_size   = "Standard_D2s_v3"
      min_count = 1
      max_count = 3
      enable_auto_scaling = true
    }
    
    # This pool will have its own dedicated subnet
    workload = {
      vm_size               = "Standard_D4s_v3"
      create_subnet         = true
      subnet_address_prefix = "10.0.10.0/24"
      min_count             = 1
      max_count             = 5
      enable_auto_scaling   = true
    }
    
    # This pool will use an existing subnet from a different VNet
    external = {
      vm_size   = "Standard_D4s_v3"
      subnet_id = "/subscriptions/.../subnets/external-subnet"
      min_count = 1
      max_count = 3
      enable_auto_scaling = true
    }
  }
}
```

## Module Structure

The module is organized into the following files:

- `main.tf` - Resource group creation
- `locals.tf` - Local values for resource naming
- `variables.tf` - Input variable definitions
- `outputs.tf` - Output value definitions
- `providers.tf` - Provider requirements
- `network.tf` - Virtual network and subnet resources
- `identity.tf` - User-assigned managed identity and role assignments
- `acr.tf` - Azure Container Registry
- `log_analytics.tf` - Log Analytics workspace and Container Insights
- `aks.tf` - AKS cluster configuration and additional node pools
- `application_gateway.tf` - Application Gateway
- `diagnostic_settings.tf` - Diagnostic settings for AKS
- `alerts.tf` - Monitoring alerts

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.11 |
| azurerm | ~> 4.0 |

## Inputs

### Required Inputs

| Name | Description | Type |
|------|-------------|------|
| owner | Owner or team name for resource naming | `string` |
| name | Base name for resources | `string` |
| env | Environment name (e.g., 'dev', 'prod', 'staging') | `string` |
| location | Azure region where resources will be deployed | `string` |

### Optional Inputs

All resource names are optional and will be auto-generated using the `{prefix}-{owner}-{name}-{env}` pattern:

| Name | Description | Type | Default |
|------|-------------|------|---------|
| resource_group_name | Name of the resource group | `string` | `rg-{owner}-{name}-{env}` |
| aks_name | Name of the AKS cluster | `string` | `aks-{owner}-{name}-{env}` |
| aks_dns_prefix | DNS prefix for the AKS cluster | `string` | `{owner}-{name}-{env}` |
| acr_name | Name of the Azure Container Registry | `string` | `acr{owner}{name}{env}` (alphanumeric) |
| app_gateway_name | Name of the Application Gateway | `string` | `agw-{owner}-{name}-{env}` |
| vnet_name | Name of the virtual network | `string` | `vnet-{owner}-{name}-{env}` |
| identity_name | Name of the user-assigned managed identity | `string` | `uai-{owner}-{name}-{env}` |
| log_analytics_workspace_name | Name of the Log Analytics workspace | `string` | `log-{owner}-{name}-{env}` |
| action_group_name | Name of the action group for alerts | `string` | `ag-{owner}-{name}-{env}` |
| create_vnet | Whether to create a new virtual network | `bool` | `true` |
| private_cluster_enabled | Whether to enable private cluster mode | `bool` | `true` |
| enable_log_analytics | Enable Log Analytics workspace | `bool` | `true` |
| enable_diagnostic_settings | Enable diagnostic settings for AKS | `bool` | `true` |
| enable_alerts | Enable monitoring alerts | `bool` | `true` |

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