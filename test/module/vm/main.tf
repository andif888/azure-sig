data "azurerm_shared_image" "vm" {
  name                = var.shared_image_name
  gallery_name        = var.gallery_name
  resource_group_name = var.gallery_resource_group_name
}

data "azurerm_shared_image_version" "vm" {
  name                = var.shared_image_version
  image_name          = data.azurerm_shared_image.vm.name
  gallery_name        = data.azurerm_shared_image.vm.gallery_name
  resource_group_name = data.azurerm_shared_image.vm.resource_group_name
}

data "azurerm_resource_group" "vm" {
  name     = var.resource_group_name
}

data "azurerm_virtual_network" "vm" {
  name                = var.virtual_network_name
  resource_group_name = var.virtual_network_resource_group_name
}

data "azurerm_subnet" "vm" {
  name                 = var.virtual_network_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vm.name
  resource_group_name  = data.azurerm_virtual_network.vm.resource_group_name
}

resource "azurerm_network_interface" "vm" {
  count                 = var.instance_count
  name                  = "${var.name}${count.index}-nic"
  location              = data.azurerm_resource_group.vm.location
  resource_group_name   = data.azurerm_resource_group.vm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.instance_count
  name                = "${var.name}${count.index}-vm"
  resource_group_name = data.azurerm_resource_group.vm.name
  location            = data.azurerm_resource_group.vm.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  license_type        = var.license_type
  source_image_id     = data.azurerm_shared_image_version.vm.id

  network_interface_ids = [element(azurerm_network_interface.vm.*.id, count.index)]

  os_disk {
    storage_account_type      = var.os_disk_storage_account_type
    caching                   = var.os_disk_caching

    dynamic "diff_disk_settings" {
      for_each = var.os_disk_ephemeral ? [1] : []
      content {
        option = "Local"
      }
    }
  }

  timezone = var.timezone

  tags                         = merge({ "resourcename" = format("%s", lower(replace(var.name, "/[[:^alnum:]]/", ""))) }, var.tags, )

}

resource "azurerm_virtual_machine_extension" "domain_join" {
  count                         = length(var.join_domain_name) > 0 ? var.instance_count : 0
  name                          = format("%s-domainJoin", lower(replace(var.name, "/[[:^alnum:]]/", "")))
  virtual_machine_id            = element(azurerm_windows_virtual_machine.vm.*.id, count.index)
  publisher                     = "Microsoft.Compute"
  type                          = "JsonADDomainExtension"
  type_handler_version          = "1.3"
  auto_upgrade_minor_version    = true

  settings = <<SETTINGS
    {
      "Name": "${var.join_domain_name}",
      "OUPath": "${var.join_domain_oupath}",
      "User": "${var.join_domain_username}@${var.join_domain_name}",
      "Restart": "true",
      "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${var.join_domain_password}"
    }
PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

}

resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  count                         = length(var.hostpool_name) > 0 ? var.instance_count : 0
  name                       = format("%s-avd_dsc", lower(replace(var.name, "/[[:^alnum:]]/", "")))
  virtual_machine_id         = element(azurerm_windows_virtual_machine.vm.*.id, count.index)
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_3-10-2021.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${var.hostpool_name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${var.hostpool_registration_token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.domain_join
  ]
}
