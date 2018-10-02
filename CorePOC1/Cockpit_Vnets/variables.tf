variable "locations" {
    
  default = ["NorthEurope", "WestEurope"]
  description = "Specify the regions in which Vnets to be deployed"
}

variable "ResourcegroupName" {
    
  default = ["VnetRGNE", "VnetRGWE"]
   description = "Specify the name of resource groups respectively"
}

variable "CircuitID" {
    
  default = ["NEcircuitID", "UKSouthcicuitID"]
   description = "circuit ID of the Vnets respectively"
}
variable "IPspace" {
    
  default = ["10.0.40.0/26", "10.0.41.0/26"]
   description = "Specify the address space for the vnets respectively"
}

variable "VNetname" {
    
  default = ["cockpitNE_vnet","CockpitWE_vnet"]
   description = "Specify the name of vnets respectively"
}

variable "GatewayName" {
    
  default = ["cockpitNE_vnetGW","CockpitWE_vnetGW"]
  description = "Specify the name of Gateways respectively"

}

variable "PublicIPName" {
    
  default = ["cockpitNE_GWPIP","CockpitWE_GWPIP"]
  description = "Specify the name of PublicIps respectively"

}

