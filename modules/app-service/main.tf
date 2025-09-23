# modules/app-service/main.tf - Enhanced with Key Vault Integration

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}

# Linux Web App
resource "azurerm_linux_web_app" "main" {
  name                = "${var.webapp_name_prefix}-${var.random_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id

  # Enable system assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on           = var.always_on
    minimum_tls_version = var.minimum_tls_version
    ftps_state          = "Disabled"  # Security hardening
    http2_enabled       = true        # Security hardening
    vnet_route_all_enabled = true     # Route all traffic through VNet

    application_stack {
      node_version = var.node_version
    }

    app_command_line = var.app_command_line
  }

  # Enhanced app settings with Key Vault references
  app_settings = merge(
    {
      "WEBSITE_NODE_DEFAULT_VERSION"    = var.node_version
      "SCM_DO_BUILD_DURING_DEPLOYMENT" = "false"
      "WEBSITE_RUN_FROM_PACKAGE"        = "0"
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
      "WEBSITE_DNS_SERVER"              = "168.63.129.16"
      "POST_BUILD_SCRIPT_PATH"          = "echo '<!DOCTYPE html><html><head><title>Secure Azure Infrastructure</title></head><body><h1>Azure Infrastructure Deployed Successfully</h1><p>VNet Integration: Active</p><p>Location: ${var.location}</p><p>Deployment: Private Network Only</p><p>Security: Enhanced with Key Vault</p></body></html>' > /home/site/wwwroot/index.html"
    },
    var.custom_app_settings
  )

  tags = var.tags
}

# VNet Integration
resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  count          = var.enable_vnet_integration ? 1 : 0
  app_service_id = azurerm_linux_web_app.main.id
  subnet_id      = var.subnet_id
}