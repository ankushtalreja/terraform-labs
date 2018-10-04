resource "azurerm_resource_group" "App_RG" {

    name = "App_RG-${var.applocations[count.index]}"
    count = "${length(var.applocations)}"
    location = "${var.applocations[count.index]}"
 
}

resource "azurerm_virtual_network" "app_Vnet" {
  
  name = "app_Vnet-${var.applocations[count.index]}"
  resource_group_name = "${element(azurerm_resource_group.App_RG.*.name, count.index)}"
  location = "${element(azurerm_resource_group.App_RG.*.location, count.index)}"
  count = "${length(var.applocations)}"
  address_space = ["${var.appaddspace[count.index]}"]
  
  }

resource "azurerm_subnet" "SQLMI" {

    name = "SQLMI"
    virtual_network_name = "${element(azurerm_virtual_network.app_Vnet.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.appaddspace[count.index]}", 3, 0)}"
    count = "${length(var.applocations)}"
   resource_group_name = "${element(azurerm_resource_group.App_RG.*.name, count.index)}"
  
}
resource "azurerm_subnet" "NEvnetdata" {

    name = "NEvnetdata"
    virtual_network_name = "${element(azurerm_virtual_network.app_Vnet.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.appaddspace[count.index]}", 3, 1)}"
    count = "${length(var.applocations)}"
   resource_group_name = "${element(azurerm_resource_group.App_RG.*.name, count.index)}"
  
}

resource "azurerm_subnet" "NEVnetcompute" {

    name = "NEVnetcompute"
    virtual_network_name = "${element(azurerm_virtual_network.app_Vnet.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.appaddspace[count.index]}", 3, 2)}"
    count = "${length(var.applocations)}"
   resource_group_name = "${element(azurerm_resource_group.App_RG.*.name, count.index)}"
   service_endpoints = ["Microsoft.Sql"]
  
}

resource "azurerm_virtual_network_peering" "AppNEtoHUBNE" {
  name                      = "AppNEtoHUBNE"
  resource_group_name       = "${element(azurerm_resource_group.App_RG.*.name, 0)}"
  virtual_network_name      = "${element(azurerm_virtual_network.app_Vnet.*.name, 0)}"
  remote_virtual_network_id = "${element(azurerm_virtual_network.HUb_vnets.*.id, 2)}"
  allow_virtual_network_access = true
  use_remote_gateways = true
  

}

resource "azurerm_virtual_network_peering" "HUBNEtoAppNE" {
  name                      = "HUBNEtoAppNE"
  resource_group_name       = "${element(azurerm_resource_group.HUB_Azure.*.name, 2)}"
  virtual_network_name      = "${element(azurerm_virtual_network.HUb_vnets.*.name, 2)}"
  remote_virtual_network_id = "${element(azurerm_virtual_network.app_Vnet.*.id, 0)}"
  allow_virtual_network_access = true
  allow_gateway_transit = true
  

}

resource "azurerm_virtual_network_peering" "AppWEtoHUBWE" {
  name                      = "AppWEtoHUBWE"
  resource_group_name       = "${element(azurerm_resource_group.App_RG.*.name, 1)}"
  virtual_network_name      = "${element(azurerm_virtual_network.app_Vnet.*.name, 1)}"
  remote_virtual_network_id = "${element(azurerm_virtual_network.HUb_vnets.*.id, 3)}"
  allow_virtual_network_access = true
  use_remote_gateways = true

}

resource "azurerm_virtual_network_peering" "HUBWEtoAppWE" {
  name                      = "HUBWEtoAppWE"
  resource_group_name       = "${element(azurerm_resource_group.HUB_Azure.*.name, 3)}"
  virtual_network_name      = "${element(azurerm_virtual_network.HUb_vnets.*.name, 3)}"
  remote_virtual_network_id = "${element(azurerm_virtual_network.app_Vnet.*.id, 1)}"
  allow_virtual_network_access = true
  allow_gateway_transit = true
  

}


