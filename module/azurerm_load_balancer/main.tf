variable "load_balancers" {}

resource "azurerm_public_ip" "lb_pip" {
  for_each            = var.load_balancers
  name                = each.value.pip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  for_each            = var.load_balancers
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip[each.key].id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  for_each        = var.load_balancers
  name            = "BackEndAddressPool"
  loadbalancer_id = azurerm_lb.lb[each.key].id
}

resource "azurerm_lb_probe" "hp" {
  for_each        = var.load_balancers
  name            = "http-running-probe"
  loadbalancer_id = azurerm_lb.lb[each.key].id
  port            = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  for_each                       = var.load_balancers
  name                           = "LBRule"
  loadbalancer_id                = azurerm_lb.lb[each.key].id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool[each.key].id]
  probe_id                       = azurerm_lb_probe.hp[each.key].id
}

data "azurerm_network_interface" "nic" {
  for_each = {
    for item in flatten([
      for lb_key, lb_val in var.load_balancers : [
        for nic in lb_val.nic_names : {
          lb_key = lb_key
          nic    = nic
          rg     = lb_val.resource_group_name
        }
      ]
    ]) : "${item.lb_key}-${item.nic}" => item
  }

  name                = each.value.nic
  resource_group_name = each.value.rg
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_assoc" {
  for_each                = data.azurerm_network_interface.nic
  network_interface_id    = each.value.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool[split("-", each.key)[0]].id
}