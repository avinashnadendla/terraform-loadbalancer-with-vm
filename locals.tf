locals {
  resources_prefix="${var.resource_group_name}-${var.resource_group_location}"
  commontags={
    locaion="eastus"
    department="tech"
  }
  web_inbound_ports_map = {
    "100" : "80", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "443",
    "120" : "22"
  } 
}