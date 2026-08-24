module "rg_prod" {
  source = "../../module/azurerm_resource_group"
  rgs1   = var.rgs2
}

module "stg_prod" {
  depends_on = [module.rg_prod]
  source = "../../module/azurerm_storage_account"
  stg1   = var.stg2
}

module "vnet_prod" {
  depends_on = [module.rg_prod]
  source     = "../../module/azurerm_virtual_network"
  vnets1     = var.vnets2
}

module "subnet_prod" {
  depends_on = [module.vnet_prod]
  source     = "../../module/azurerm_subnet"
  subnets1   = var.subnets2
}

module "nat_gw_prod" {
  depends_on   = [module.subnet_prod]
  source       = "../../module/azurerm_nat_gateway"
  nat_gateways = var.nat_gateways
}

module "nic_prod" {
  depends_on = [module.subnet_prod]
  source     = "../../module/azurerm_network_interface"
  nic        = var.nics
}

module "vm_prod" {
  depends_on = [module.nic_prod]
  source     = "../../module/azurerm_virtual_machine"
  linux_vms  = var.vms2
}

module "lb_prod" {
  depends_on     = [module.vm_prod]
  source         = "../../module/azurerm_load_balancer"
  load_balancers = var.load_balancers
}

module "bastion_prod" {
  depends_on = [module.subnet_prod]
  source     = "../../module/azurerm_bastion_host"
  bastions   = var.bastions
}