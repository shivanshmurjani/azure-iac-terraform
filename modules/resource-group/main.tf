# modules/resource-group/main.tf

resource "azurerm_resource_group" "main" {
  name     = "${var.rg_name_prefix}-${var.random_suffix}"
  location = var.location
  tags     = var.tags
}