# modules/security/outputs.tf

output "nsg_webapp_id" {
  description = "ID of the webapp NSG"
  value       = azurerm_network_security_group.webapp.id
}

output "nsg_webapp_name" {
  description = "Name of the webapp NSG"
  value       = azurerm_network_security_group.webapp.name
}

output "nsg_private_endpoint_id" {
  description = "ID of the private endpoint NSG"
  value       = azurerm_network_security_group.private_endpoints.id
}

output "nsg_private_endpoint_name" {
  description = "Name of the private endpoint NSG"
  value       = azurerm_network_security_group.private_endpoints.name
}

output "nsg_test_vm_id" {
  description = "ID of the test VM NSG"
  value       = azurerm_network_security_group.test_vm.id
}

output "nsg_test_vm_name" {
  description = "Name of the test VM NSG"
  value       = azurerm_network_security_group.test_vm.name
}