# modules/key-vault/outputs.tf

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "private_endpoint_id" {
  description = "ID of the Key Vault private endpoint"
  value       = azurerm_private_endpoint.keyvault.id
}

output "private_dns_zone_id" {
  description = "ID of the Key Vault private DNS zone"
  value       = azurerm_private_dns_zone.keyvault.id
}