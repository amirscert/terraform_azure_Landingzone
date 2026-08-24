variable "vnets1" {}

resource "azurerm_virtual_network" "vnets" {
  for_each            = var.vnets1
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.address_space
}

