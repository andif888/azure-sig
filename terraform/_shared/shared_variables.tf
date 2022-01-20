
variable "azure_location" {
  type    = string
  default = "Germany West Central"
}

variable "azure_resource_group_name" {
  type        = string
  default     = ""
  description = ""
}

variable "azure_shared_image_gallery_name" {
  type    = string
  default = ""
}

variable "azure_shared_image_gallery_description" {
  type    = string
  default = "Share Image Gallery for automatic packer builds"
}

variable "azure_managed_image_name" {
  type    = string
  default = ""
}

variable "azure_managed_image_publisher" {
  type    = string
  default = ""
}

variable "azure_managed_image_offer" {
  type    = string
  default = ""
}

variable "azure_managed_image_sku" {
  type    = string
  default = ""
}

variable "azure_managed_image_hyper_v_generation" {
  type        = string
  default     = "V1"
  description = "The generation of HyperV that the Virtual Machine used to create the Shared Image is based on. Possible values are V1 and V2. Defaults to V1. Changing this forces a new resource to be created."
}

variable "azure_os_type" {
  type    = string
  default = "Windows"
}

variable "azure_tags" {
  type        = map(string)
  description = "(map[string]string) - Name/value pair tags to apply to every resource deployed i.e. Resource Group, VM, NIC, VNET, Public IP, KeyVault, etc. The user can define up to 15 tags. Tag names cannot exceed 512 characters, and tag values cannot exceed 256 characters."

  default = {
    source = "packer"
  }
}

variable "azure_bootstrap_resource_group_name" {
  type    = string
  default = ""
}
variable "azure_bootstrap_storage_account_name" {
  type    = string
  default = ""
}
variable "azure_bootstrap_storage_account_container_name" {
  type    = string
  default = ""
}
