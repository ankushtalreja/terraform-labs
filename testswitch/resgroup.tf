//create resource group for PROD Vnets
resource "azurerm_resource_group" "tstrgw" {

    name = "switchrg1"
    count = "${var.env == "1" ? 1 : 0}"
    location = "ukwest"
    tags {
        environemnt = "production"
    }
 
}

resource "azurerm_resource_group" "tstrgw2" {

    name = "switchrg1"
    count = "${var.env == "0" ? 1 : 0}"
    location = "ukwest"
 
}