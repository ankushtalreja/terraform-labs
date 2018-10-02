resource "azurerm_resource_group" "VnetsRG" {

    name = "${var.ResourcegroupName[count.index]}"
    count = "${length(var.locations)}"
    location = "${var.locations[count.index]}"
 
}

resource "azurerm_virtual_network" "vnets" {
  
  name = "${var.VNetname[count.index]}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  location = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
  count = "${length(var.locations)}"
  address_space = ["${var.IPspace[count.index]}"]

  
  }
resource "azurerm_subnet" "gwsubnt" {

    name = "GatewaySubnet"
    virtual_network_name = "${element(azurerm_virtual_network.vnets.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.IPspace[count.index]}", 2, 0)}"
    count = "${length(var.locations)}"
   resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  
}
resource "azurerm_subnet" "mgmt" {

    name = "dsdsd"
    virtual_network_name = "${element(azurerm_virtual_network.vnets.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.IPspace[count.index]}", 2, 1)}"
    count = "${length(var.locations)}"
   resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  
}

resource "azurerm_subnet" "KVsubnet" {

    name = "compute"
    virtual_network_name = "${element(azurerm_virtual_network.vnets.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.IPspace[count.index]}", 2, 2)}"
    count = "${length(var.locations)}"
   resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  
}

resource "azurerm_public_ip" "gatewaypip" {
  
  name = "${var.PublicIPName[count.index]}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  public_ip_address_allocation = "Dynamic"
  count = "${length(var.locations)}"
location = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
}

resource "azurerm_virtual_network_gateway" "Vnet_gateway" {
  
  name = "${var.GatewayName[count.index]}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  location = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
  type = "expressroute"
  count = "${length(var.locations)}"
  sku           = "standard"
    ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${element(azurerm_public_ip.gatewaypip.*.id, count.index)}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${element(azurerm_subnet.gwsubnt.*.id, count.index)}"
    
  }

}
/*
resource "azurerm_virtual_network_gateway_connection" "ERconnection" {

     name                = "${element(azurerm_virtual_network.vnets.*.name, count.index)}-connection"
  location            = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"

  type                          = "expressroute"
  express_route_circuit_id = "${var.CircuitID[count.index]}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.Vnet_gateway.*.id, count.index)}"


  
  
}
*/

