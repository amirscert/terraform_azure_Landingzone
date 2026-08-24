variable "nat_gateways" {}

resource "azurerm_public_ip" "nat_pip" {
  for_each            = var.nat_gateways
  name                = each.value.pip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat_gw" {
  for_each            = var.nat_gateways
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_pip_assoc" {
  for_each             = var.nat_gateways
  nat_gateway_id       = azurerm_nat_gateway.nat_gw[each.key].id
  public_ip_address_id = azurerm_public_ip.nat_pip[each.key].id
}


resource "azurerm_subnet_nat_gateway_association" "subnet_assoc" {
  for_each       = data.azurerm_subnet.subnets
  subnet_id      = each.value.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw[split("-", each.key)[0]].id
}