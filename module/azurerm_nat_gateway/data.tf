data "azurerm_subnet" "subnets" {
  for_each = {
    for item in flatten([
      for nat_key, nat_val in var.nat_gateways : [
        for snet in nat_val.subnet_names : {
          nat_key = nat_key
          snet    = snet
          vnet    = nat_val.virtual_network_name
          rg      = nat_val.resource_group_name
        }
      ]
    ]) : "${item.nat_key}-${item.snet}" => item
  }

  name                 = each.value.snet
  virtual_network_name = each.value.vnet
  resource_group_name  = each.value.rg
}