  
variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "East US"
}

variable "admin_username" {
  description = "The Azure username for which all resources in this example should be created."
  default = "adminuser"
}


variable "admin_password" {
  description = "The Azure admin password for which all resources in this example should be created."
  default = "P@ssw0rd1234!"
}

variable "count_" {
  description = "The number of VMs need to be provisioned."
  default = 2
}