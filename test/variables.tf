# Azure Shared

# adjust variables dependent on staging or production environment

variable "azure_subscription_id" {
    # override in credentials.tfvars
    # (should) staging != producion
    type = string
    default = ""  # (Visual Studio Enterprise – MPN)
    description = "Azure Subscription ID. In Azure Portal click Cost Management + Billing. Here you find your asigned Subscription ID"
}
variable "azure_client_id" {
    # override in credentials.tfvars
    # (should) staging != producion
    type = string
    default = ""    # (pr_infra_staging )
    description = "Azure Client ID. This is the Application ID of the registered App in Azure Portal"
}
variable "azure_client_secret" {
    # override in credentials.tfvars
    # (should) staging != producion
    type = string
    default = ""      # (key1)
    description = "Azure Client Secret. This is the key's password value of the registered App in the Azure Portal"
}
variable "azure_tenant_id" {
    # override in credentials.tfvars
    # (can) staging == producion
    type = string
    default = ""
    description = "Azure Tenant ID. In Azure Portal click Azure Active Directory -> Properties an note th Directory ID"
}

# Azure VM

variable "azure_vm_admin_username" {
    type = string
    default = ""
}

variable "azure_vm_admin_password" {
    type = string
    default = ""
}

# Join Domain

variable "azure_vm_join_domain_name" {
    type = string
    default = ""
}

variable "azure_vm_join_domain_oupath" {
    type = string
    default = ""
}

variable "azure_vm_join_domain_username" {
    type = string
    default = ""
}

variable "azure_vm_join_domain_password" {
    type = string
    default = ""
}
