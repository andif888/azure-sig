# Name of the publisher to use for your base image (source image) (Azure Marketplace Images only).
azure_image_publisher           = "MicrosoftWindowsDesktop"

# Name of the publisher's offer to use for your base image (source image) (Azure Marketplace Images only).
azure_image_offer               = "Windows-11"

# SKU of the image offer to use for your base image (source image) (Azure Marketplace Images only).
azure_image_sku                 = "win11-21h2-avd"

# Storage account of the managed image in the shared image gallery
azure_shared_image_gallery_destination_storage_account_type = "Standard_LRS"

# Size of the VM used for building. This can be changed when you deploy a VM
azure_vm_size                   = "Standard_D2ds_v4"

# The main ansible playbook which packer executes
ansible_playbook_file           = "../../ansible/playbook-de-windows-11-avd.yml"
#
