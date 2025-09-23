# variables.tf

# Azure Region
variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
  default     = "Central India"
}

# Resource Group Name Prefix
variable "rg_name_prefix" {
  description = "Prefix for the Resource Group name"
  type        = string
  default     = "rg-azure-iac-terraform"
}

# Virtual Network Name
variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "vnet-secure-webapp"
}

# Subnet Name
variable "subnet_name" {
  description = "Name of the subnet for the web app"
  type        = string
  default     = "subnet-webapp"
}

# App Service Plan Name
variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "asp-secure-webapp"
}

# Web App Name Prefix
variable "webapp_name_prefix" {
  description = "Prefix for the Web App name"
  type        = string
  default     = "webapp-secure-iac"
}

# Node Version
variable "node_version" {
  description = "Node.js version for the Linux Web App"
  type        = string
  default     = "18-lts"
}

# Storage Account Name Prefix
variable "storage_account_prefix" {
  description = "Prefix for the Storage Account name"
  type        = string
  default     = "stgsecureapp"
}

# Key Vault Name Prefix
variable "key_vault_prefix" {
  description = "Prefix for the Key Vault name"
  type        = string
  default     = "kv-secure-app"
}

# Tags
variable "tags" {
  description = "Common tags for all resources"
  type = map(string)
  default = {
    Environment = "Test"
    Project     = "Azure-IAC-Terraform"
    ManagedBy   = "Terraform"
  }
}

#redeployment test