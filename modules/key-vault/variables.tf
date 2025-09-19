# modules/key-vault/variables.tf

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
}

variable "key_vault_prefix" {
  description = "Prefix for the Key Vault name"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for unique naming"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID of the user/service principal"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Key Vault"
  type        = string
  default     = "standard"
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