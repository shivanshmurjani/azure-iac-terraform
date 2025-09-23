# modules/security/variables.tf

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
}

variable "vnet_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "webapp_subnet_id" {
  description = "ID of the webapp subnet"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet"
  type        = string
}

variable "test_vm_subnet_id" {
  description = "ID of the test VM subnet"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}