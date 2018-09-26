resource "azurerm_resource_group" "core" {

    name = "core"
    location = "${var.loc}"
    tags = "${var.tags}"
  
}
resource "azurerm_public_ip" "mytfpip" {
  
  name = "mytfpip"
  resource_group_name = "${azurerm_resource_group.core.name}"
  public_ip_address_allocation = "Dynamic"
  location = "${azurerm_resource_group.core.location}"
}

resource "azurerm_virtual_network" "mytfvnet" {
  
  name = "mytfvnet"
  resource_group_name = "${azurerm_resource_group.core.name}"
  location = "${azurerm_resource_group.core.location}"
  address_space = ["10.0.80.0/20"]
  dns_servers         = ["1.1.1.1", "1.0.0.1"]

 
 
  }

resource "azurerm_subnet" "gwsubnt" {

    name = "GatewaySubnet"
    virtual_network_name = "${azurerm_virtual_network.mytfvnet.name}"
    address_prefix       = "10.0.80.0/24"
    resource_group_name = "${azurerm_resource_group.core.name}"
  
}
resource "azurerm_subnet" "training" {

    name = "training"
    virtual_network_name = "${azurerm_virtual_network.mytfvnet.name}"
    address_prefix       = "10.0.81.0/24"
    resource_group_name = "${azurerm_resource_group.core.name}"
  
}
resource "azurerm_subnet" "dev" {

    name = "dev"
    virtual_network_name = "${azurerm_virtual_network.mytfvnet.name}"
    address_prefix       = "10.0.82.0/24"
    resource_group_name = "${azurerm_resource_group.core.name}"
  
}

/*resource "azurerm_virtual_network_gateway" "mytfgtw" {
  
  name = "mytfgtw"
  resource_group_name = "${azurerm_resource_group.core.name}"
  location = "${azurerm_resource_group.core.location}"
  type = "Vpn"
  vpn_type = "routebased"
  active_active = false
  enable_bgp    = true
  sku           = "Basic"
    ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.mytfpip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.gwsubnt.id}"
    
  }

}
*/

  

  

  






