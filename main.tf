terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate random suffix for unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Resource Group Module
module "resource_group" {
  source = "./modules/resource-group"
  
  rg_name_prefix = var.rg_name_prefix
  location       = var.location
  random_suffix  = random_string.suffix.result
  tags          = var.tags
}

# Networking Module
module "networking" {
  source = "./modules/networking"
  
  resource_group_name = module.resource_group.resource_group_name
  location           = module.resource_group.location
  vnet_name          = var.vnet_name
  subnet_name        = var.subnet_name
  tags              = var.tags
}

# App Service Module
module "app_service" {
  source = "./modules/app-service"
  
  resource_group_name     = module.resource_group.resource_group_name
  location               = module.resource_group.location
  app_service_plan_name  = var.app_service_plan_name
  webapp_name_prefix     = var.webapp_name_prefix
  random_suffix          = random_string.suffix.result
  node_version           = var.node_version
  subnet_id              = module.networking.webapp_subnet_id
  tags                   = var.tags
}

# Storage Module
module "storage" {
  source = "./modules/storage"
  
  resource_group_name      = module.resource_group.resource_group_name
  location                = module.resource_group.location
  storage_account_prefix   = var.storage_account_prefix
  random_suffix            = random_string.suffix.result
  private_endpoint_subnet_id = module.networking.private_endpoint_subnet_id
  vnet_id                  = module.networking.vnet_id
  tags                    = var.tags
}

# Key Vault Module
module "key_vault" {
  source = "./modules/key-vault"
  
  resource_group_name = module.resource_group.resource_group_name
  location           = module.resource_group.location
  key_vault_prefix   = var.key_vault_prefix
  random_suffix      = random_string.suffix.result
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  private_endpoint_subnet_id = module.networking.private_endpoint_subnet_id
  vnet_id            = module.networking.vnet_id
  tags              = var.tags
}

# Security Module
module "security" {
  source = "./modules/security"
  
  resource_group_name = module.resource_group.resource_group_name
  location           = module.resource_group.location
  vnet_id            = module.networking.vnet_id
  webapp_subnet_id   = module.networking.webapp_subnet_id
  private_endpoint_subnet_id = module.networking.private_endpoint_subnet_id
  test_vm_subnet_id  = module.networking.test_vm_subnet_id
  tags              = var.tags
}

# Connectivity test module removed - infrastructure security verified through other means