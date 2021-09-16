resource "azurerm_linux_virtual_machine" "vm" {
  count = var.count_value
  name = "${var.linuxvm_name}-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  source_image_reference {
       publisher = "Canonical"
       offer = "UbuntuServer"
       sku = "18.04-LTS"
       version = "latest"
  }
  admin_username = "demouser"
  admin_password = "avinash@2002"
  computer_name = "avinashvm--${count.index}"
  network_interface_ids = [
      element(azurerm_network_interface.ni[*].id,count.index)
    ]
  size = "Standard_DS1_v2"
  tags = {
      "environment" = "dev"
  } 
  os_disk {
    name = "demo_disk-${count.index}"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }
  disable_password_authentication = false


}