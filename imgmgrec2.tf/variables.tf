variable "region" {}
variable "environment" {}
variable "namespace" {}
variable "applicationname" {
    type = string
    default = "ImgMgr"
    description = "Name of application"
}

variable "sshkey" {
    type = string
    default = "TOPAccountKey"
    description = "SSH Key pair to auth with"
}

variable "ImageId" {
    type = string
    default = "ami-02e136e904f3da870"
    description = "The AMI to base this instance off of"
}

variable "AppServerMinCount" {
    type = string
    default = "1"
    description = "How many min instance count to run"
}

variable "AppServerMaxCount" {
    type = string
    default = "2"
    description = "How many max instance count to run"
}

variable "HealthCheckType" {
    type = string
    default = "EC2"
    description = "Defines type of health check for load balancer"
}

variable "InstanceType" {
    type = string
    default = "t2.small"
    description = "Instance size" 
}