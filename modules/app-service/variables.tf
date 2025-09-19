# modules/app-service/variables.tf

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "os_type" {
  description = "OS type for the App Service Plan"
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "SKU name for the App Service Plan"
  type        = string
  default     = "B1"
}

variable "webapp_name_prefix" {
  description = "Prefix for the Web App name"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for unique naming"
  type        = string
}

variable "node_version" {
  description = "Node.js version for the Linux Web App"
  type        = string
  default     = "18-lts"
}

variable "always_on" {
  description = "Should the web app be always on"
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "app_command_line" {
  description = "App command line for the web app"
  type        = string
  default     = "echo '<!DOCTYPE html><html><head><title>Secure Infrastructure</title></head><body><h1>Azure Infrastructure Deployed Successfully</h1><p>VNet Integration: Active</p><p>Deployed via: Terraform + GitHub Actions</p></body></html>' > /home/site/wwwroot/index.html && npm start"
}

variable "custom_app_settings" {
  description = "Custom app settings for the web app"
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "ID of the subnet for VNet integration"
  type        = string
  default     = null
}

variable "enable_vnet_integration" {
  description = "Enable VNet integration for the web app"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}