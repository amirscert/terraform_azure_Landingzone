variable "stg1" {}

resource "azurerm_storage_account" "stg" {
  for_each = var.stg1
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  # Bad Practice: Public Access Allowed!
  allow_nested_items_to_be_public = each.value.allow_nested_items_to_be_public
}