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

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet"
  value       = azurerm_subnet.private_endpoints.id
}

output "private_endpoint_subnet_name" {
  description = "Name of the private endpoint subnet"
  value       = azurerm_subnet.private_endpoints.name
}

output "test_vm_subnet_id" {
  description = "ID of the test VM subnet"
  value       = azurerm_subnet.test_vm.id
}

output "test_vm_subnet_name" {
  description = "Name of the test VM subnet"
  value       = azurerm_subnet.test_vm.name
}