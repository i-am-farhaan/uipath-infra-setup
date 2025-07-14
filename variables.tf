variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}
variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
  default     = "West Europe"
  
}
variable "vnet_name" {
  description = "The name of the resource group"
  type        = string
  default     = "uipath-vnet"
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for VM"
  type        = string
  sensitive   = true
}