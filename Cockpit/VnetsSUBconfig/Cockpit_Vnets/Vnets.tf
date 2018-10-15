//create resource group for PROD Vnets
resource "azurerm_resource_group" "VnetsRG" {

    name = "${var.ResourcegroupName[count.index]}"
    count = "${length(var.locations)}"
    location = "${var.locations[count.index]}"
 
}

//Create NSG for Key Vault Subnet



//create PROD Vnets and subnets

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
    address_prefix       = "${cidrsubnet("${var.IPspace[count.index]}", 4, 4)}"
    count = "${length(var.locations)}"
   resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  
}
resource "azurerm_subnet" "mgmt" {

    name = "${var.mgmtsubnetname[count.index]}"
    virtual_network_name = "${element(azurerm_virtual_network.vnets.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.IPspace[count.index]}", 3, 0)}"
    count = "${length(var.locations)}"
   resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
   network_security_group_id ="${element(azurerm_network_security_group.MGMTsubnetNSG.*.id, count.index)}"
  
}
//Key vault subnet with Key vault service endpoint
resource "azurerm_subnet" "KVsubnet" {

    name = "${var.keyvaultsubnetname[count.index]}"
    virtual_network_name = "${element(azurerm_virtual_network.vnets.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.IPspace[count.index]}", 3, 1)}"
    count = "${length(var.locations)}"
   resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
   service_endpoints = ["Microsoft.KeyVault"]
   network_security_group_id ="${element(azurerm_network_security_group.KVsubnetNSG.*.id, count.index)}"
  
}

//create Gateway Public IP
resource "azurerm_public_ip" "gatewaypip" {
  
  name = "${var.PublicIPName[count.index]}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  public_ip_address_allocation = "Dynamic"
  count = "${length(var.locations)}"
location = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
}

//Can Not Delete lock on resource group
resource "azurerm_management_lock" "resource-group-levelvnet" {
  name       = "${var.ResourcegroupName[count.index]}-CNDlock"
  scope      = "${element(azurerm_resource_group.VnetsRG.*.id, count.index)}"
  lock_level = "CanNotDelete"
  notes      = "This Resource Group cannot be deleted"
  count = "${length(var.ResourcegroupName)}"
}

//create Gateway
/*
resource "azurerm_virtual_network_gateway" "Vnet_gateway" {
  
  name = "${var.GatewayName[count.index]}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  location = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
  type = "expressroute"
  count = "${length(var.locations)}"
  sku           = "${var.gatewaySKU}"
    ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${element(azurerm_public_ip.gatewaypip.*.id, count.index)}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${element(azurerm_subnet.gwsubnt.*.id, count.index)}"
    
  }

}

//connecting both gateways to North Europe Cicuit

//If vnets created are in non-prod subscription i.e. authorization key required
resource "azurerm_virtual_network_gateway_connection" "VnteconnectiontoNEcircuitnonprod" {

     name                = "conntoNEcircuit"
  location            = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  type                          = "ExpressRoute"
  count = "${var.Environment == "N" ? "${length(var.locations)}" : 0}"
  virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.Vnet_gateway.*.id, count.index)}"

  express_route_circuit_id = "${var.NECircuitID}"
  authorization_key = "${var.NECircuitAuthkey}"
  
}


//If vnets created are in prod subscription i.e. authorization key NOT required
resource "azurerm_virtual_network_gateway_connection" "VnteconnectiontoNEcircuitprod" {

     name                = "conntoNEcircuit"
  location            = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
  type                          = "ExpressRoute"
  count = "${var.Environment == "P" ? "${length(var.locations)}" : 0}"
  virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.Vnet_gateway.*.id, count.index)}"

  express_route_circuit_id = "${var.NECircuitID}"
  
  
}

//connecting both gateways to UkSouth Cicuit
//If vnets created are in non-prod subscription i.e. authorization key required
resource "azurerm_virtual_network_gateway_connection" "VneconnectiontoUKSouthcircuitnonprod" {

     name                = "conntoUkSouthcircuit"
  location            = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
 count = "${var.Environment == "N" ? "${length(var.locations)}" : 0}"
  type                          = "ExpressRoute"
  virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.Vnet_gateway.*.id, count.index)}"
  express_route_circuit_id = "${var.UKSOuthCircuitID}"
  authorization_key = "${var.UKSOuthCircuitAUthKey}"
 
  
}

//If vnets created are in non-prod subscription i.e. authorization key required
resource "azurerm_virtual_network_gateway_connection" "VneconnectiontoUKSouthcircuitprod" {

     name                = "conntoUkSouthcircuit"
  location            = "${element(azurerm_resource_group.VnetsRG.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"
 count = "${var.Environment == "P" ? "${length(var.locations)}" : 0}"
  type                          = "ExpressRoute"
  virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.Vnet_gateway.*.id, count.index)}"
  express_route_circuit_id = "${var.UKSOuthCircuitID}"

   
}
*/