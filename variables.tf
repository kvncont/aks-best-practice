# Naming Configuration
variable "owner" {
  type        = string
  description = "Owner or team name for resource naming"
}

variable "name" {
  type        = string
  description = "Base name for resources (e.g., 'myapp')"
}

variable "env" {
  type        = string
  description = "Environment name (e.g., 'dev', 'prod', 'staging')"
}

# Resource Group
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group (optional, defaults to rg-{owner}-{name}-{env})"
  default     = null
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

# Network Configuration
variable "create_vnet" {
  type        = bool
  description = "Whether to create a new virtual network or use an existing one"
  default     = true
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network (optional, defaults to vnet-{owner}-{name}-{env})"
  default     = null
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the virtual network (required if create_vnet is true)"
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet for AKS"
  default     = "aks-subnet"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Address prefix for the AKS subnet (required if create_vnet is true)"
  default     = "10.0.1.0/24"
}

variable "subnet_id" {
  type        = string
  description = "ID of existing subnet for AKS (required if create_vnet is false)"
  default     = null
}

variable "enable_vnet_peering" {
  type        = bool
  description = "Enable VNet peering from created VNet to external VNets when using external subnets"
  default     = true
}

variable "app_gateway_subnet_name" {
  type        = string
  description = "Name of the subnet for Application Gateway"
  default     = "appgw-subnet"
}

variable "app_gateway_subnet_address_prefix" {
  type        = string
  description = "Address prefix for the Application Gateway subnet"
  default     = "10.0.2.0/24"
}

# Network Configuration for AKS
variable "network_plugin" {
  type        = string
  description = "Network plugin to use (azure, kubenet)"
  default     = "azure"
}

# AKS Configuration
variable "aks_name" {
  type        = string
  description = "Name of the AKS cluster (optional, defaults to aks-{owner}-{name}-{env})"
  default     = null
}

variable "aks_dns_prefix" {
  type        = string
  description = "DNS prefix for the AKS cluster (optional, defaults to {owner}-{name}-{env})"
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the AKS cluster"
  default     = null
}

variable "private_cluster_enabled" {
  type        = bool
  description = "Whether to enable private cluster mode"
  default     = true
}

variable "sku_tier" {
  type        = string
  description = "SKU tier for the AKS cluster (Free, Standard, Premium)"
  default     = "Standard"
  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be one of: Free, Standard, Premium"
  }
}

# Default Node Pool Configuration
variable "default_node_pool_name" {
  type        = string
  description = "Name of the default node pool"
  default     = "system"
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "VM size for the default node pool"
  default     = "Standard_D2s_v3"
}

variable "default_node_pool_node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 2
}

variable "default_node_pool_min_count" {
  type        = number
  description = "Minimum number of nodes for auto-scaling"
  default     = null
}

variable "default_node_pool_max_count" {
  type        = number
  description = "Maximum number of nodes for auto-scaling"
  default     = null
}

variable "default_node_pool_enable_auto_scaling" {
  type        = bool
  description = "Enable auto-scaling for the default node pool"
  default     = false
}

variable "default_node_pool_max_pods" {
  type        = number
  description = "Maximum number of pods per node"
  default     = 30
}

variable "default_node_pool_os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB for the default node pool"
  default     = 128
}

variable "default_node_pool_zones" {
  type        = list(string)
  description = "Availability zones for the default node pool"
  default     = ["1", "2", "3"]
}

# Additional Node Pools
variable "additional_node_pools" {
  type = map(object({
    vm_size               = string
    subnet_id             = optional(string)
    create_subnet         = optional(bool, false)
    subnet_address_prefix = optional(string)
    node_count            = optional(number, 1)
    min_count             = optional(number)
    max_count             = optional(number)
    enable_auto_scaling   = optional(bool, false)
    max_pods              = optional(number, 30)
    os_disk_size_gb       = optional(number, 128)
    zones                 = optional(list(string), ["1", "2", "3"])
    node_labels           = optional(map(string), {})
    node_taints           = optional(list(string), [])
  }))
  description = "Map of additional node pools to create. Each pool can optionally specify a subnet_id to use an existing subnet, or set create_subnet=true with subnet_address_prefix to create a new dedicated subnet."
  default     = {}
}

variable "network_plugin_mode" {
  type        = string
  description = "Network plugin mode (overlay for Azure CNI Overlay)"
  default     = "overlay"
}

variable "pod_cidr" {
  type        = string
  description = "CIDR for pod network (required for Azure CNI Overlay)"
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  type        = string
  description = "CIDR for Kubernetes services"
  default     = "10.245.0.0/16"
}

variable "dns_service_ip" {
  type        = string
  description = "IP address for Kubernetes DNS service"
  default     = "10.245.0.10"
}

# Azure Container Registry
variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry (optional, defaults to acr{owner}{name}{env} - alphanumeric only)"
  default     = null
}

variable "acr_sku" {
  type        = string
  description = "SKU for the Azure Container Registry"
  default     = "Premium"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "acr_sku must be one of: Basic, Standard, Premium"
  }
}

variable "acr_public_network_access_enabled" {
  type        = bool
  description = "Whether to allow public network access to ACR"
  default     = false
}

# Application Gateway
variable "app_gateway_name" {
  type        = string
  description = "Name of the Application Gateway (optional, defaults to agw-{owner}-{name}-{env})"
  default     = null
}

variable "app_gateway_sku" {
  type        = string
  description = "SKU for the Application Gateway"
  default     = "Standard_v2"
}

variable "app_gateway_capacity" {
  type        = number
  description = "Capacity for the Application Gateway"
  default     = 2
}

# Log Analytics
variable "enable_log_analytics" {
  type        = bool
  description = "Enable Log Analytics workspace"
  default     = true
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of the Log Analytics workspace (optional, defaults to log-{owner}-{name}-{env})"
  default     = null
}

variable "log_analytics_sku" {
  type        = string
  description = "SKU for the Log Analytics workspace"
  default     = "PerGB2018"
}

variable "log_analytics_retention_days" {
  type        = number
  description = "Retention days for Log Analytics"
  default     = 30
}

# Diagnostic Settings
variable "enable_diagnostic_settings" {
  type        = bool
  description = "Enable diagnostic settings for AKS"
  default     = true
}

variable "diagnostic_setting_name" {
  type        = string
  description = "Name of the diagnostic setting"
  default     = "aks-diagnostics"
}

variable "diagnostic_logs" {
  type        = list(string)
  description = "List of log categories to enable"
  default = [
    "kube-apiserver",
    "kube-controller-manager",
    "kube-scheduler",
    "kube-audit",
    "cluster-autoscaler"
  ]
}

variable "diagnostic_metrics" {
  type        = list(string)
  description = "List of metric categories to enable"
  default     = ["AllMetrics"]
}

# Alerts
variable "enable_alerts" {
  type        = bool
  description = "Enable monitoring alerts"
  default     = true
}

variable "action_group_name" {
  type        = string
  description = "Name of the action group for alerts (optional, defaults to ag-{owner}-{name}-{env})"
  default     = null
}

variable "action_group_short_name" {
  type        = string
  description = "Short name for the action group"
  default     = "aksalerts"
}

variable "alert_email_receivers" {
  type = list(object({
    name          = string
    email_address = string
  }))
  description = "List of email receivers for alerts"
  default     = []
}

# User Assigned Identity
variable "identity_name" {
  type        = string
  description = "Name of the user-assigned managed identity (optional, defaults to uai-{owner}-{name}-{env})"
  default     = null
}
