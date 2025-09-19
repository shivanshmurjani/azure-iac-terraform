# modules/security/main.tf

# Network Security Group for Web App Subnet
resource "azurerm_network_security_group" "webapp" {
  name                = "nsg-webapp"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow HTTPS traffic from within VNet
  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Allow HTTP traffic from within VNet (for testing)
  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow outbound traffic within VNet
  security_rule {
    name                       = "AllowVNetOutbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  # Allow outbound HTTPS to Azure services
  security_rule {
    name                       = "AllowAzureOutbound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }

  tags = var.tags
}

# Network Security Group for Private Endpoints Subnet
resource "azurerm_network_security_group" "private_endpoints" {
  name                = "nsg-private-endpoints"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow inbound traffic from VNet
  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow outbound traffic within VNet
  security_rule {
    name                       = "AllowVNetOutbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.tags
}

# Associate NSG with Web App Subnet
resource "azurerm_subnet_network_security_group_association" "webapp" {
  subnet_id                 = var.webapp_subnet_id
  network_security_group_id = azurerm_network_security_group.webapp.id
}

# Associate NSG with Private Endpoints Subnet
resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = var.private_endpoint_subnet_id
  network_security_group_id = azurerm_network_security_group.private_endpoints.id
}

# Network Security Group for Test VM Subnet
resource "azurerm_network_security_group" "test_vm" {
  name                = "nsg-test-vm"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow SSH from within VNet
  security_rule {
    name                       = "AllowSSHInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Allow inbound traffic from VNet
  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow outbound traffic within VNet
  security_rule {
    name                       = "AllowVNetOutbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  # Allow outbound HTTPS to Azure services
  security_rule {
    name                       = "AllowAzureOutbound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }

  tags = var.tags
}

# Associate NSG with Test VM Subnet
resource "azurerm_subnet_network_security_group_association" "test_vm" {
  subnet_id                 = var.test_vm_subnet_id
  network_security_group_id = azurerm_network_security_group.test_vm.id
}