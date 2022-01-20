# Resulting name of the managed image in the share image gallery
# azure_managed_image_name        = "en-windows-2022-small-packer"                            # !! set by commandline

############################################
# only used by Packer but centrally defined
############################################

# Name of the publisher to use for your base image (source image) (Azure Marketplace Images only).
azure_image_publisher           = "MicrosoftWindowsServer"

# Name of the publisher's offer to use for your base image (source image) (Azure Marketplace Images only).
azure_image_offer               = "WindowsServer"

# SKU of the image offer to use for your base image (source image) (Azure Marketplace Images only).
azure_image_sku                 = "2022-Datacenter-smalldisk"

# Specify the size of the OS disk in GB (gigabytes). Values of zero or less than zero are ignored.
azure_os_disk_size_gb           = 48

# Resulting version of the managed image in the shared image gallery
# azure_shared_image_gallery_destination_image_version        = "1.0.1"                     # !! set by commandline

# Storage account of the managed image in the shared image gallery
azure_shared_image_gallery_destination_storage_account_type = "Standard_LRS"

# Size of the VM used for building. This can be changed when you deploy a VM
azure_vm_size                   = "Standard_D2ds_v4"

# The main ansible playbook which packer executes
ansible_playbook_file           = "../../ansible/playbook.yml"
#
