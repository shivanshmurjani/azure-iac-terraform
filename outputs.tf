# outputs.tf

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = module.resource_group.resource_group_name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = module.resource_group.location
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.networking.vnet_name
}

output "webapp_subnet_id" {
  description = "ID of the webapp subnet"
  value       = module.networking.webapp_subnet_id
}

output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = module.app_service.app_service_plan_id
}

output "webapp_name" {
  description = "Name of the web app"
  value       = module.app_service.webapp_name
}

output "webapp_url" {
  description = "Default hostname of the web app"
  value       = module.app_service.webapp_url
}

output "webapp_id" {
  description = "ID of the web app"
  value       = module.app_service.webapp_id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.storage.storage_account_id
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.key_vault_name
}

output "nsg_webapp_id" {
  description = "ID of the webapp NSG"
  value       = module.security.nsg_webapp_id
}

output "nsg_private_endpoint_id" {
  description = "ID of the private endpoint NSG"
  value       = module.security.nsg_private_endpoint_id
}

# Connectivity test VM removed - security can be verified through Azure portal and CLI