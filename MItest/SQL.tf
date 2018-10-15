resource "azurerm_resource_group" "testMI" {
  name     = "acctestRG-02"
  location = "NorthEurope"
}

resource "azurerm_virtual_network" "Mivnet" {
  
  name = "Mivnet"
  resource_group_name = "${azurerm_resource_group.testMI.name}"
  location = "${azurerm_resource_group.testMI.location}"
  address_space = ["10.0.10.0/24"]

  
  }

resource "azurerm_route_table" "RoutesMI" {

name = "traftoazure"
location = "${azurerm_resource_group.testMI.location}"
resource_group_name = "${azurerm_resource_group.testMI.name}"

disable_bgp_route_propagation = "false"

  route {
    name           = "route1"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "internet"
  }


}

resource "azurerm_subnet" "MIsubnet" {

    name = "MIsubnet"
    virtual_network_name = "${azurerm_virtual_network.Mivnet.name}"
    address_prefix       = "${cidrsubnet("${azurerm_virtual_network.Mivnet.address_space[0]}", 3, 0)}"
    resource_group_name = "${azurerm_resource_group.testMI.name}"
    route_table_id = "${azurerm_route_table.RoutesMI.id}"
  
}
resource "azurerm_template_deployment" "test" {
  name                = "acctesttemplate-01"
  resource_group_name = "${azurerm_resource_group.testMI.name}"
  

  template_body = <<DEPLOY
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
   "resources": [

       {
  "name": "mytestMI",
  "type": "Microsoft.Sql/managedInstances",
  "apiVersion": "2015-05-01-preview",
  "location": "NorthEurope",
  "tags": {},
  "identity": {
    "type": "SystemAssigned"
  },
  "sku": {
    "name": "GP_Gen4",
    "tier": "GeneralPurpose"

 
  },
  "properties": {
    "administratorLogin": "ankush",
    "administratorLoginPassword": "Welcome@123456789",
    "subnetId": "/subscriptions/98c9f11a-7427-4292-8d76-5e02713d6cd4/resourceGroups/testMI/providers/Microsoft.Network/virtualNetworks/Mivnet/subnets/MISubnet",
    "licenseType": "LicenseIncluded",
    "vCores": "16",
    "storageSizeInGB": "32"
  }
}
   ]
}
DEPLOY

  # these key-value pairs are passed into the ARM Template's `parameters` block
 

  deployment_mode = "Incremental"
}

