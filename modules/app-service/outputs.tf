# modules/app-service/outputs.tf

output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.main.id
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.main.name
}

output "webapp_id" {
  description = "ID of the web app"
  value       = azurerm_linux_web_app.main.id
}

output "webapp_name" {
  description = "Name of the web app"
  value       = azurerm_linux_web_app.main.name
}

output "webapp_url" {
  description = "Default hostname of the web app"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "webapp_default_hostname" {
  description = "Default hostname of the web app"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "webapp_identity_principal_id" {
  description = "Principal ID of the web app managed identity"
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}

output "webapp_identity_tenant_id" {
  description = "Tenant ID of the web app managed identity"
  value       = azurerm_linux_web_app.main.identity[0].tenant_id
}