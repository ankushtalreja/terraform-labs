resource "azurerm_resource_group" "satestrg" {
  name     = "${var.SAresourcegroupname[count.index]}"
  location = "${var.locations[count.index]}"
  count = "${length(var.locations)}"
}

resource "azurerm_storage_account" "testsa" {
  name                     = "${var.storageaccname[count.index]}"
  resource_group_name = "${element(azurerm_resource_group.satestrg.*.name, count.index)}"
  location = "${element(azurerm_resource_group.satestrg.*.location, count.index)}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier = "Hot"
  enable_blob_encryption = "true"
  enable_file_encryption = "true"
  enable_https_traffic_only = "true"
  account_kind = "StorageV2"
  count = "${length(var.locations)}"

  

}



//Can Not Delete lock on resource group
resource "azurerm_management_lock" "resource-group-levelSA" {
  name       = "${var.SAresourcegroupname[count.index]}-CNDlock"
  scope      = "${element(azurerm_resource_group.satestrg.*.id, count.index)}"
  lock_level = "CanNotDelete"
  notes      = "This Resource Group cannot be deleted"
  count = "${length(var.SAresourcegroupname)}"
}