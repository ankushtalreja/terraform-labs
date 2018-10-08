resource "azurerm_resource_group" "test" {
  name     = "${var.loganalyticsRGname}"
  location = "WestEurope"
}

resource "azurerm_log_analytics_workspace" "laworspace" {
  name                = "${var.LAworkspacename}"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  sku                 = "Standard"
  retention_in_days   = 30
}

//Can Not Delete lock on resource group
resource "azurerm_management_lock" "resource-group-levella" {
  name       = "${var.loganalyticsRGname}-CNDlock"
  scope      = "${azurerm_resource_group.test.id}"
  lock_level = "CanNotDelete"
  notes      = "This Resource Group cannot be deleted"
}