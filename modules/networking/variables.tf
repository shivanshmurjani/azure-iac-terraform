# modules/networking/variables.tf

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet for the web app"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the webapp subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_endpoint_subnet_name" {
  description = "Name of the subnet for private endpoints"
  type        = string
  default     = "subnet-private-endpoints"
}

variable "private_endpoint_subnet_address_prefixes" {
  description = "Address prefixes for the private endpoint subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "test_vm_subnet_name" {
  description = "Name of the subnet for test VM"
  type        = string
  default     = "subnet-test-vm"
}

variable "test_vm_subnet_address_prefixes" {
  description = "Address prefixes for the test VM subnet"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}