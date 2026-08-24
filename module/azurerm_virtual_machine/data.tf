data "azurerm_network_interface" "nic" {
  for_each = var.linux_vms
  name                = each.value.nic_name
  resource_group_name = each.value.resource_group_name
}
