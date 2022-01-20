data "azurerm_resource_group" "windows" {
  name = var.azure_resource_group_name
}

data "azurerm_shared_image_gallery" "windows" {
  name                = var.azure_shared_image_gallery_name
  resource_group_name = data.azurerm_resource_group.windows.name
}

resource "azurerm_shared_image" "windows" {
  name                = var.azure_managed_image_name
  gallery_name        = data.azurerm_shared_image_gallery.windows.name
  resource_group_name = data.azurerm_resource_group.windows.name
  location            = data.azurerm_resource_group.windows.location
  os_type             = var.azure_os_type

  identifier {
    publisher = var.azure_managed_image_publisher
    offer     = var.azure_managed_image_offer
    sku       = var.azure_managed_image_sku
  }

  hyper_v_generation = var.azure_managed_image_hyper_v_generation
  tags               = var.azure_tags
}

output "azurerm_shared_image_id" {
  value = azurerm_shared_image.windows.id
}
output "azurerm_shared_image_name" {
  value = azurerm_shared_image.windows.name
}
output "azurerm_shared_image_gallery_id" {
  value = data.azurerm_shared_image_gallery.windows.id
}
output "azurerm_shared_image_gallery_name" {
  value = data.azurerm_shared_image_gallery.windows.name
}
output "azurerm_resource_group_id" {
  value = data.azurerm_resource_group.windows.id
}
output "azurerm_resource_group_name" {
  value = data.azurerm_resource_group.windows.name
}
