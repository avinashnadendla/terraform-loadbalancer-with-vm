resource "azurerm_public_ip" "demo_ip" {
  name = "lb_ip"
  allocation_method = "Static"
  sku = "Standard"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}



resource "azurerm_lb" "demo_lb" {
    name =  var.loadb_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "Standard"
    frontend_ip_configuration {
      name = "frontendiplb1"
      public_ip_address_id = azurerm_public_ip.demo_ip.id
      private_ip_address_allocation = "Dynamic"
    }    
}

resource "azurerm_lb_backend_address_pool" "backendlbpool" {
    name = "demo_backend_pool_lb"
    loadbalancer_id = azurerm_lb.demo_lb.id
  
}

resource "azurerm_lb_rule" "demolbrule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.demo_lb.id
  name                           = "demolbrule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.demo_lb.frontend_ip_configuration[0].name
}

resource "azurerm_lb_nat_rule" "demonatrule" {
  depends_on = [
    azurerm_lb_backend_address_pool.backendlbpool,
    azurerm_lb_rule.demolbrule,
    azurerm_network_interface_backend_address_pool_association.web_nic_lb_associate
  ]
  count=var.count_value
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.demo_lb.id
  name                           = "SSH-natrule-${element(var.nat_list,count.index)}"
  protocol                       = "Tcp"
  frontend_port                  = element(var.nat_list,count.index)
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.demo_lb.frontend_ip_configuration[0].name


}


resource "azurerm_lb_probe" "name" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.demo_lb.id
  name                = "port80-running-probe"
  port                = 80
}

resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  count = var.count_value
  network_interface_id    = element(azurerm_network_interface.ni[*].id,count.index)
  ip_configuration_name   = element(azurerm_network_interface.ni[*].ip_configuration[0].name,count.index)
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendlbpool.id
}

resource "azurerm_network_interface_nat_rule_association" "demo_nat_association" {
  count = var.count_value
  ip_configuration_name =element(azurerm_network_interface.ni[*].ip_configuration[0].name,count.index)
  network_interface_id = element(azurerm_network_interface.ni[*].id,count.index)
  nat_rule_id = element(azurerm_lb_nat_rule.demonatrule[*].id,count.index)
}