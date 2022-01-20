# Azure VM

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {}
}

variable "admin_username" {
    type = string
    default = ""
}

variable "admin_password" {
    type = string
    default = ""
}

variable "name"  {
  type = string
  default = ""
}

variable "instance_count" {
    type = number
    default = 1
}

variable "size" {
    type = string
    default = "Standard_D2ds_v5"
}

variable "license_type" {
  type = string
  default = "Windows_Server"
  description = "(Optional) Specifies the BYOL Type for this Virtual Machine. This is only applicable to Windows Virtual Machines. Possible values are Windows_Client and Windows_Server"
}

variable "gallery_resource_group_name" {
  type = string
  default = ""
}

variable "gallery_name" {
  type = string
  default = ""
}

variable "shared_image_name" {
  type = string
  default = ""
}

variable "shared_image_version" {
  type = string
  default = "latest"
}

variable "resource_group_name" {
    # (must) staging != producion
    type = string
    description = "The Azure Resource Group"
    default = ""
}

variable "virtual_network_resource_group_name" {
  type = string
  default = ""
}

variable "virtual_network_name" {
    # (should) staging != producion
    type = string
    description = "The name of the virtual network"
    default = ""
}
variable "virtual_network_subnet_name" {
    # (can) staging == producion
    type = string
    description = "The name of the virtual network's subnet"
    default = ""
}

variable "os_disk_storage_account_type" {
    type = string
    default = "Standard_LRS"
}
variable "os_disk_caching" {
    type = string
    default = "ReadWrite"
}
variable "os_disk_ephemeral" {
    type = bool
    default = false
}

variable "join_domain_name" {
  type = string
  default = ""
}

variable "join_domain_oupath" {
    type = string
    default = ""
}

variable "join_domain_username" {
    type = string
    default = ""
}

variable "join_domain_password" {
    type = string
    default = ""
}

variable "hostpool_name" {
    type = string
    default = ""
}
variable "hostpool_registration_token" {
    type = string
    default = ""
}
