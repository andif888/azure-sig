# Azure Shared

# adjust variables dependent on staging or production environment

variable "azure_subscription_id" {
  # override in credentials.tfvars
  # (should) staging != producion
  type        = string
  default     = "" # (Visual Studio Enterprise – MPN)
  description = "Azure Subscription ID. In Azure Portal click Cost Management + Billing. Here you find your asigned Subscription ID"
}
variable "azure_client_id" {
  # override in credentials.tfvars
  # (should) staging != producion
  type        = string
  default     = "" # (pr_infra_staging )
  description = "Azure Client ID. This is the Application ID of the registered App in Azure Portal"
}
variable "azure_client_secret" {
  # override in credentials.tfvars
  # (should) staging != producion
  type        = string
  default     = "" # (key1)
  description = "Azure Client Secret. This is the key's password value of the registered App in the Azure Portal"
}
variable "azure_tenant_id" {
  # override in credentials.tfvars
  # (can) staging == producion
  type        = string
  default     = ""
  description = "Azure Tenant ID. In Azure Portal click Azure Active Directory -> Properties an note th Directory ID"
}

# Azure VM

variable "azure_vm_admin_username" {
  type    = string
  default = ""
}

variable "azure_vm_admin_password" {
  type    = string
  default = ""
}

# Join Domain

variable "azure_vm_join_domain_name" {
  type    = string
  default = ""
}

variable "azure_vm_join_domain_oupath" {
  type    = string
  default = ""
}

variable "azure_vm_join_domain_username" {
  type    = string
  default = ""
}

variable "azure_vm_join_domain_password" {
  type    = string
  default = ""
}

# Hostpool
variable "azure_vm_hostpool_name" {
  type    = string
  default = ""
}
variable "azure_vm_hostpool_registration_token" {
  type    = string
  default = ""
}

variable "azure_vm_name" {
  type    = string
  default = ""
}
variable "azure_vm_instance_count" {
  type    = number
  default = 1
}
variable "azure_vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}
variable "azure_vm_license_type" {
  type    = string
  default = "None"
}
variable "azure_vm_gallery_resource_group_name" {
  type    = string
  default = ""
}

variable "azure_vm_gallery_name" {
  type    = string
  default = ""
}
variable "azure_vm_shared_image_name" {
  type    = string
  default = ""
}
variable "azure_vm_shared_image_version" {
  type    = string
  default = "latest"
}



variable "azure_vm_resource_group_name" {
  type    = string
  default = ""
}
variable "azure_vm_virtual_network_resource_group_name" {
  type    = string
  default = ""
}
variable "azure_vm_virtual_network_name" {
  type    = string
  default = ""
}
variable "azure_vm_virtual_network_subnet_name" {
  type    = string
  default = ""
}
variable "azure_vm_os_disk_storage_account_type" {
  type    = string
  default = "Standard_LRS"
}
variable "azure_vm_os_disk_caching" {
  type    = string
  default = "ReadWrite"
}
variable "azure_vm_os_disk_ephemeral" {
  type    = bool
  default = false
}
variable "azure_vm_timezone" {
  type    = string
  default = ""
}

# not used but to suppress warnings
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
variable "azure_shared_image_gallery_name" {
  type    = string
  default = ""
}
variable "azure_location" {
  type    = string
  default = "Germany West Central"
}
variable "azure_resource_group_name" {
  type        = string
  default     = ""
  description = ""
}
