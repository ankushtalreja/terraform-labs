data "azurerm_virtual_network" "test" {
  name                 = "cockpitNE_vnet"
  resource_group_name  = "VnetRGNE"
}

output "virtual_network_id" {
  value = "${data.azurerm_virtual_network.test.id}"
}