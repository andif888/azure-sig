module "azure_virtual_desktop_vm" {
  source                              = "./module/vm"
  admin_username                      = var.azure_vm_admin_username
  admin_password                      = var.azure_vm_admin_password
  name                                = var.azure_vm_name
  instance_count                      = var.azure_vm_instance_count
  size                                = var.azure_vm_size
  license_type                        = var.azure_vm_license_type
  gallery_resource_group_name         = var.azure_vm_gallery_resource_group_name
  gallery_name                        = var.azure_vm_gallery_name
  shared_image_name                   = var.azure_vm_shared_image_name
  shared_image_version                = var.azure_vm_shared_image_version
  resource_group_name                 = var.azure_vm_resource_group_name
  virtual_network_resource_group_name = var.azure_vm_virtual_network_resource_group_name
  virtual_network_name                = var.azure_vm_virtual_network_name
  virtual_network_subnet_name         = var.azure_vm_virtual_network_subnet_name
  os_disk_storage_account_type        = var.azure_vm_os_disk_storage_account_type
  os_disk_caching                     = var.azure_vm_os_disk_caching
  os_disk_ephemeral                   = var.azure_vm_os_disk_ephemeral
  # Optional variables
  join_domain_name            = var.azure_vm_join_domain_name
  join_domain_username        = var.azure_vm_join_domain_username
  join_domain_password        = var.azure_vm_join_domain_password
  join_domain_oupath          = var.azure_vm_join_domain_oupath
  hostpool_name               = var.azure_vm_hostpool_name
  hostpool_registration_token = var.azure_vm_hostpool_registration_token
  tags = {
    "environment"                 = "test",
    "gallery_resource_group_name" = var.azure_vm_gallery_resource_group_name,
    "gallery_name"                = var.azure_vm_gallery_name,
    "shared_image_name"           = var.azure_vm_shared_image_name,
    "shared_image_version"        = var.azure_vm_shared_image_version
  }
  timezone = var.azure_vm_timezone
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
