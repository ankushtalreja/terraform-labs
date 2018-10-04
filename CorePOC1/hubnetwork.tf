
data "azurermke" "name" {
  
}



resource "azurerm_resource_group" "HUB_Azure" {

    name = "HUB_Azure-${var.locations[count.index]}"
    count = "${length(var.locations)}"
    location = "${var.locations[count.index]}"
 
}

resource "azurerm_virtual_network" "HUb_vnets" {
  
  name = "HUB_Vnet-${var.locations[count.index]}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, count.index)}"
  location = "${element(azurerm_resource_group.HUB_Azure.*.location, count.index)}"
  count = "${length(var.locations)}"
  address_space = ["${var.addspace[count.index]}"]

  
  }
resource "azurerm_subnet" "gwsubnt" {

    name = "GatewaySubnet"
    virtual_network_name = "${element(azurerm_virtual_network.HUb_vnets.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.addspace[count.index]}", 3, 0)}"
    count = "${length(var.locations)}"
   resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, count.index)}"
   
  
}
resource "azurerm_subnet" "data" {

    name = "data"
    virtual_network_name = "${element(azurerm_virtual_network.HUb_vnets.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.addspace[count.index]}", 3, 1)}"
    count = "${length(var.locations)}"
   resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, count.index)}"
  
}

resource "azurerm_subnet" "compute" {

    name = "compute"
    virtual_network_name = "${element(azurerm_virtual_network.HUb_vnets.*.name, count.index)}"
    address_prefix       = "${cidrsubnet("${var.addspace[count.index]}", 3, 2)}"
    count = "${length(var.locations)}"
   resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, count.index)}"
  
}

resource "azurerm_public_ip" "gatewaypip" {
  
  name = "gatewaypip"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, count.index)}"
  public_ip_address_allocation = "Dynamic"
  count = "${length(var.locations)}"
  location =  "${element(azurerm_resource_group.HUB_Azure.*.location, count.index)}"
}

resource "azurerm_virtual_network_gateway" "HUB_gateway" {
  
  name = "HUB_gateway"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, count.index)}"
  location = "${element(azurerm_resource_group.HUB_Azure.*.location, count.index)}"
  type = "Vpn"
  vpn_type = "routebased"
  count = "${length(var.locations)}"
  active_active = false
  enable_bgp    = false
  sku           = "Basic"
    ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${element(azurerm_public_ip.gatewaypip.*.id, count.index)}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${element(azurerm_subnet.gwsubnt.*.id, count.index)}"
    
  }

}

resource "azurerm_virtual_network_gateway_connection" "HubconnectionUkSouthtoWesteurope" {

     name                = "HubconnectionUkSouthtoWesteurope"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 0)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 0)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 0)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 3)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}
resource "azurerm_virtual_network_gateway_connection" "HubconnectionWestEuropetoUKSouth" {

     name                = "HubconnectionWestEuropetoUKSouth"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 3)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 3)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 3)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 0)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}

resource "azurerm_virtual_network_gateway_connection" "HubconnectionUkSouthtoNortheurope" {

     name                = "HubconnectionUkSouthtoNortheurope"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 0)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 0)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 0)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 2)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}
resource "azurerm_virtual_network_gateway_connection" "HubconnectionNorthEuropetoUKSouth" {

     name                = "HubconnectionNorthEuropetoUKSouth"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 2)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 2)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 2)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 0)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}

resource "azurerm_virtual_network_gateway_connection" "HubconnectionUKWesttoNortheurope" {

     name                = "HubconnectionUKWesttoNortheurope"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 1)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 1)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 1)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 2)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}
resource "azurerm_virtual_network_gateway_connection" "HubconnectionNorthEuropetoUKWest" {

     name                = "HubconnectionNorthEuropetoUKWest"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 2)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 2)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 2)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 1)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}

resource "azurerm_virtual_network_gateway_connection" "HubconnectionUKWesttoWesteurope" {

     name                = "HubconnectionUKWesttoWesteurope"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 1)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 1)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 1)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 3)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}
resource "azurerm_virtual_network_gateway_connection" "HubconnectionWestEuropetoUKWest" {

     name                = "HubconnectionWestEuropetoUKWest"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 3)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 3)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 3)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 1)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}


resource "azurerm_virtual_network_gateway_connection" "HubconnectionUKWesttoUKSouth" {

     name                = "HubconnectionUKWesttoUKSouth"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 1)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 1)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 1)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 0)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}
resource "azurerm_virtual_network_gateway_connection" "HubconnectionUKSouthtoUKWest" {

     name                = "HubconnectionUKSouthtoUKWest"
  location            = "${element(azurerm_resource_group.HUB_Azure.*.location, 0)}"
  resource_group_name = "${element(azurerm_resource_group.HUB_Azure.*.name, 0)}"

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 0)}"
  peer_virtual_network_gateway_id = "${element(azurerm_virtual_network_gateway.HUB_gateway.*.id, 1)}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  
  
}
