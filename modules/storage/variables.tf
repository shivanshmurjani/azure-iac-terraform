# modules/storage/variables.tf

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
}

variable "storage_account_prefix" {
  description = "Prefix for the Storage Account name"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for unique naming"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "public_network_access_enabled" {
  description = "Enable public network access for the storage account"
  type        = bool
  default     = false
}

variable "allow_nested_items_to_be_public" {
  description = "Allow nested items to be public"
  type        = bool
  default     = false
}

variable "network_rules_default_action" {
  description = "Default action for network rules"
  type        = string
  default     = "Deny"
}

variable "network_rules_bypass" {
  description = "Bypass rules for network access"
  type        = list(string)
  default     = ["AzureServices"]
}

variable "private_endpoint_subnet_id" {
  description = "ID of the subnet for private endpoints"
  type        = string
}

variable "vnet_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}