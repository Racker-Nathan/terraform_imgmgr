# Variable definitions
variable "region" {}
variable "environment" {}

#VPC Variables
variable "VpcCidr" {
  type = string
  default = "10.132.120.0/21"
  description = "Please enter the IP range (CIDR notation) for this VPC"
}

variable "publicsubnet1cidr" {
  type = string
  default = "10.132.120.0/24"
  description = "Please enter the IP range (CIDR notation) for the public subnet in the first Availability Zone"
}

variable "publicsubnet2cidr" {
  type = string
  default = "10.132.121.0/24"
  description = "Please enter the IP range (CIDR notation) for the public subnet in the second Availability Zone"
}

variable "privatesubnet1cidr" {
  type = string
  default = "10.132.123.0/24"
  description = "Please enter the IP range (CIDR notation) for the private subnet in the first Availability Zone"
}

variable "privatesubnet2cidr" {
  type = string
  default = "10.132.124.0/24"
  description = "Please enter the IP range (CIDR notation) for the private subnet in the second Availability Zone"
}
