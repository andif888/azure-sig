############################
# Azure Shared Image Gallery
############################

# Specify the managed image resource group name where the result of the Packer build will be saved.
azure_resource_group_name       = "plyg02_sig_rg"

# Azure datacenter in which your VM will build.
azure_location                  = "Germany West Central"

# Name of the shared image gallery
azure_shared_image_gallery_name = "plyg02_sig"


################################################################################
# Existing Azure Storage Account and container for storing terraform state files
################################################################################

# The following azure resrouces must already exist.
# You can manually create them or use
# https://github.com/andif888/azure-bootstrap

# Name of the resource-group hosting a storage account for terraform state files.
 azure_bootstrap_resource_group_name = "rg-plyg02-bootstrap"

# Name of the storage account to save terraform state files
azure_bootstrap_storage_account_name = "stplyg02bs"

# Name of the blob container to save terraform state files
azure_bootstrap_storage_account_container_name = "terraformstates"
