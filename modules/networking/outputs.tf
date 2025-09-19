# modules/networking/outputs.tf

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "webapp_subnet_id" {
  description = "ID of the webapp subnet"
  value       = azurerm_subnet.webapp.id
}

output "webapp_subnet_name" {
  description = "Name of the webapp subnet"
  value       = azurerm_subnet.webapp.name
}