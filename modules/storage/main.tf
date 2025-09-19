# modules/storage/main.tf

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = "${var.storage_account_prefix}${var.random_suffix}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  public_network_access_enabled   = var.public_network_access_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public

  network_rules {
    default_action = var.network_rules_default_action
    bypass         = var.network_rules_bypass
  }

  tags = var.tags
}