resource "azurerm_resource_group" "windows" {
  name     = var.azure_resource_group_name
  location = var.azure_location
}

resource "azurerm_shared_image_gallery" "windows" {
  name                = var.azure_shared_image_gallery_name
  resource_group_name = azurerm_resource_group.windows.name
  location            = azurerm_resource_group.windows.location
  description         = var.azure_shared_image_gallery_description

  tags = var.azure_tags
}

output "azurerm_resource_group_id" {
  value = azurerm_resource_group.windows.id
}
output "azurerm_shared_image_gallery_id" {
  value = azurerm_shared_image_gallery.windows.id
}
