variable "Deploylocations" {
    
  default = ["NorthEurope", "UKSouth", "UKWest", "WestEurope"]
  description = "Specify the regions in which resource deployment is allowed in VNet subscriptions."
}

variable "Deployloc" {
    
  default = "WestEurope"
  description = "Specify the regions in which resource deployment is allowed in VNet subscriptions."
}

