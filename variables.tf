variable "resource_group_name" {

}

variable "resource_group_location" {
  
}

variable "virtual_network_name" {
  
}

variable "address_space" {
  type = list(string)
}

variable "public_ip_name" {
  
}

variable "vnet_subnet_name" {
  
}

variable "network_interface_1" {
  
}
variable "linuxvm_name" {
  
}

variable "nsg_name" {
  description = "Name of the nsg"
  
}

variable "loadb_name" {
  description = "Name of the load balancers"
}

variable "count_value"{
  type = number
}

variable "nat_list" {
  type = list(string)
}