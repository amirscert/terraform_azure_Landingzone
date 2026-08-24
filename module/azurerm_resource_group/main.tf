variable "rgs1" {}

resource "azurerm_resource_group" "rgp" {
  for_each = var.rgs1
  name     = each.value.name
  location = each.value.location
}
