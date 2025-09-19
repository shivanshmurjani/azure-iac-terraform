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

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.rg_name_prefix}-${random_string.suffix.result}"
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# Subnet for Web App
resource "azurerm_subnet" "webapp" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "webapp-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = var.tags
}

# Linux Web App
resource "azurerm_linux_web_app" "main" {
  name                = "${var.webapp_name_prefix}-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on           = true
    minimum_tls_version = "1.2"

    application_stack {
      node_version = var.node_version
    }

    app_command_line = "echo '<!DOCTYPE html><html><head><title>Secure Infrastructure</title></head><body><h1>Azure Infrastructure Deployed Successfully</h1><p>VNet Integration: Active</p><p>Region: ${var.location}</p><p>Deployed via: Terraform + GitHub Actions</p></body></html>' > /home/site/wwwroot/index.html && npm start"
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = var.node_version
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "false"
    "WEBSITE_RUN_FROM_PACKAGE"        = "0"
    "POST_BUILD_SCRIPT_PATH"          = "echo '<!DOCTYPE html><html><head><title>Secure Azure Infrastructure</title></head><body><h1>Azure Infrastructure Deployed</h1><p>VNet Integration: Active</p><p>Location: ${var.location}</p></body></html>' > /home/site/wwwroot/index.html"
  }

  tags = var.tags
}

# VNet Integration
resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  app_service_id = azurerm_linux_web_app.main.id
  subnet_id      = azurerm_subnet.webapp.id
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = "${var.storage_account_prefix}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  tags = var.tags
}
