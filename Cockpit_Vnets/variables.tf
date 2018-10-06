
//Index- 0 for North Europe, 1 for West Europe
variable "locations" {
    
  default = ["NorthEurope", "WestEurope"]
  description = "Specify the regions in which Vnets to be deployed"
}

variable "ResourcegroupName" {
    
  default = ["VnetRGNE", "VnetRGWE"]
   description = "Specify the name of resource groups respectively"
}

variable "UKSOuthCircuitID" {
    
  default = "dsdsds"
   description = "circuit ID of the Express Route circuit in UK South "
}


variable "NECircuitID" {
    
  default = "NEcircuitID"
   description = "circuit ID of the Express Route circuit in North Europe "
}

variable "UKSOuthCircuitAUthKey" {
    
  default = "dsdsds"
   description = "circuit authorization Key of the Express Route circuit in UK South "
}

variable "NECircuitAuthkey" {
    
  default = "ddd"
   description = "circuit authorization key of the Express Route circuit in North Europe "
}
variable "IPspace" {
    
  default = ["10.0.40.0/24", "10.0.41.0/24"]
   description = "Specify the address space for the vnets respectively"
}

variable "KVsubnetNSGname" {
  default = ["kvsubnsgNE", "kvsubnsgUKS"]
   description = "Specify the name of NSG for the Key Vault subnets respectively"
}

variable "MGMTsubnetNSGname" {
  default = ["MGMTsubnsgNE", "MGMTsubnsgUKS"]
   description = "Specify the name of NSG for the management subnets respectively"
}

variable "VNetname" {
    
  default = ["cockpitNE_vnet","CockpitWE_vnet"]
   description = "Specify the name of vnets respectively"
}

variable "mgmtsubnetname" {
    
  default = ["NEmgmtsubnet","UKSmgmtsubnet"]
   description = "Specify the name of management subnets for both regions respectively"
}

variable "keyvaultsubnetname" {
    
  default = ["NEKVSUbnet","UKSKVsubnet"]
   description = "Specify the name of key Vault subnets for both regions respectively"
}

variable "GatewayName" {
    
  default = ["cockpitNE_vnetGW","CockpitWE_vnetGW"]
  description = "Specify the name of Gateways respectively"

}
variable "gatewaySKU" {
    
  default = "Standard"
   description = "Gateway SKU. Options are Standard, HighPerformance, UltraPerformance"
}
variable "PublicIPName" {
    
  default = ["cockpitNE_GWPIP","CockpitWE_GWPIP"]
  description = "Specify the name of PublicIps respectively"

}

