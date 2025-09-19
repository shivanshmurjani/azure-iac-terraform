# modules/app-service/main.tf

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

  site_config {
    always_on           = var.always_on
    minimum_tls_version = var.minimum_tls_version

    application_stack {
      node_version = var.node_version
    }

    app_command_line = var.app_command_line
  }

  app_settings = merge(
    {
      "WEBSITE_NODE_DEFAULT_VERSION"    = var.node_version
      "SCM_DO_BUILD_DURING_DEPLOYMENT" = "false"
      "WEBSITE_RUN_FROM_PACKAGE"        = "0"
      "POST_BUILD_SCRIPT_PATH"          = "echo '<!DOCTYPE html><html><head><title>Secure Azure Infrastructure</title></head><body><h1>Azure Infrastructure Deployed</h1><p>VNet Integration: Active</p><p>Location: ${var.location}</p></body></html>' > /home/site/wwwroot/index.html"
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