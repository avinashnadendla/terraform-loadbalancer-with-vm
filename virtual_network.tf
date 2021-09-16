resource "azurerm_virtual_network" "vn" {
  name = var.virtual_network_name
  location = azurerm_resource_group.rg.location
  address_space = var.address_space
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "vn_snet1" {
    resource_group_name = azurerm_resource_group.rg.name
    name=var.vnet_subnet_name
    address_prefixes = ["10.0.0.0/24"] 
    virtual_network_name = azurerm_virtual_network.vn.name
}

# resource "azurerm_public_ip" "pubip" {
  # name = var.public_ip_name
  # allocation_method = "Dynamic"
  # location = azurerm_resource_group.rg.location
  # resource_group_name = azurerm_resource_group.rg.name
# }

resource "azurerm_network_interface" "ni" {
    count = var.count_value
    name = "${var.network_interface_1}-${count.index}"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    
    ip_configuration {
      name = "internal-${count.index}"
      private_ip_address_allocation = "Dynamic"
      subnet_id = azurerm_subnet.vn_snet1.id
    }  
}

resource "azurerm_network_security_group" "demo-nsg" {
  name = var.nsg_name
  location = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  
}

resource "azurerm_network_security_rule" "demo" {
  depends_on = [
    azurerm_network_security_group.demo-nsg
  ]
  for_each = local.web_inbound_ports_map
  name                        = "rule-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.demo-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "association1" {
  depends_on = [
    azurerm_network_security_rule.demo
  ]
  network_security_group_id = azurerm_network_security_group.demo-nsg.id
  subnet_id = azurerm_subnet.vn_snet1.id
  
}