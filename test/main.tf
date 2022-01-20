terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  # version = "~> 2.19"
  features {}

  subscription_id                   = var.azure_subscription_id
  client_id                         = var.azure_client_id
  client_secret                     = var.azure_client_secret
  tenant_id                         = var.azure_tenant_id
}

module "azure_virtual_desktop_vm" {
    source = "./module/vm"
    admin_username                            = var.azure_vm_admin_username
    admin_password                            = var.azure_vm_admin_password
    name                                      = "test"
    instance_count                            = 1
    size                                      = "Standard_D4ds_v5"
    license_type                              = "Windows_Client"
    gallery_resource_group_name               = "dwm-images-rg"
    gallery_name                              = "WindowsVirtualDesktop"
    shared_image_name                         = "windows10ms-avd-o365-g2-base"
    shared_image_version                      = "latest"
    resource_group_name                       = "dwm-wvd-rg"
    virtual_network_resource_group_name       = "dwm-network-rg"
    virtual_network_name                      = "dwm-wvd-vnet"
    virtual_network_subnet_name               = "dwm-wvd-vnet-wvd-sub"
    os_disk_storage_account_type              = "Standard_LRS"
    os_disk_caching                           = "ReadOnly"
    os_disk_ephemeral                         = true
    # Optional variables
    join_domain_name                          = var.azure_vm_join_domain_name
    join_domain_username                      = var.azure_vm_join_domain_username
    join_domain_password                      = var.azure_vm_join_domain_password
    join_domain_oupath                        = var.azure_vm_join_domain_oupath
    # hostpool_name                             = ""
    # hostpool_registration_token               = ""
    tags                                      = {
      "environment" = "test"
    }
}


output "vm_ids" {
    value = module.azure_virtual_desktop_vm.avd_vm_ids
}
output "vm_private_ip_addresses" {
    value = module.azure_virtual_desktop_vm.avd_vm_private_ip_addresses
}
output "vm_virtual_machine_ids" {
    value = module.azure_virtual_desktop_vm.avd_vm_virtual_machine_ids
}
