resource "azurerm_network_security_group" "KVsubnetNSG" {
    name = "${var.KVsubnetNSGname[count.index]}"
    count = "${length(var.locations)}"
    location = "${var.locations[count.index]}"
    resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"


  security_rule {
    name                       = "allowSSHfromonprem"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes   = ["22.127.32.0/24", "22.127.33.0/24", "35.56.161.0/24", "35.56.162.0/24"]
    destination_address_prefix = "*"
  }



  
  security_rule {
    name                       = "allowRDPfromonprem"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes     = ["22.127.32.0/24", "22.127.33.0/24", "35.56.161.0/24", "35.56.162.0/24"]
    destination_address_prefix = "*"
  }

  security_rule{
    name                       = "allowLBinbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix  =  "AzureloadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Blockallinbound"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "AllowoutboundKeyvaultaccess"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureKeyVault"
  }
    security_rule {
    name                       = "Blockalloutbound"
    priority                   = 3000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

//NSG for management Subnet

resource "azurerm_network_security_group" "MGMTsubnetNSG" {
    name = "${var.MGMTsubnetNSGname[count.index]}"
    count = "${length(var.locations)}"
    location = "${var.locations[count.index]}"
    resource_group_name = "${element(azurerm_resource_group.VnetsRG.*.name, count.index)}"

  security_rule {
    name                       = "allowSSHfromonprem"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes      = ["22.127.32.0/24", "22.127.33.0/24", "35.56.161.0/24", "35.56.162.0/24"]
    destination_address_prefix = "*"
  }



  
  security_rule {
    name                       = "allowRDPfromonprem"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes    = ["22.127.32.0/24", "22.127.33.0/24", "35.56.161.0/24", "35.56.162.0/24"]
    destination_address_prefix = "*"
  }

    security_rule{
    name                       = "allowLBinbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix  =  "AzureloadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Blockallinbound"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

   
    security_rule {
    name                       = "Blockalloutbound"
    priority                   = 3000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}