packer {
  required_plugins {
    azure = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/azure"
    }
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
    }
  }
}

variable "azure_client_id" {
    type        = string
    default     = env("ARM_CLIENT_ID")
    description = "The Active Directory service principal associated with your builder."
}

variable "azure_client_secret" {
    type        = string
    default     = env("ARM_CLIENT_SECRET")
    description = "The password or secret for your service principal."
}

variable "azure_subscription_id" {
    type        = string
    default     = env("ARM_SUBSCRIPTION_ID")
    description = "Subscription under which the build will be performed"
}

variable "azure_tenant_id" {
    type        = string
    default     = env("ARM_TENANT_ID")
    description = "The Active Directory tenant identifier with which your client_id and subscription_id are associated. If not specified, tenant_id will be looked up using subscription_id."
}

variable "azure_vm_size" {
  type          = string
  default       = "Standard_B2s"
  description   = "Size of the VM used for building. This can be changed when you deploy a VM from your VHD."
}

variable "azure_location" {
  type          = string
  default       = env("TF_VAR_azure_location")
  description   = "Azure datacenter in which your VM will build."
}

variable "azure_image_publisher" {
  type          = string
  default       = "MicrosoftWindowsDesktop"
  description   = "Name of the publisher to use for your base image (Azure Marketplace Images only)."
}
variable "azure_image_offer" {
  type          = string
  default       = "windows-11"
  description   = "Name of the publisher's offer to use for your base image (Azure Marketplace Images only)."
}

variable "azure_image_sku" {
  type          = string
  default       = "win11-21h2-avd"
  description   = "SKU of the image offer to use for your base image (Azure Marketplace Images only)."
}

variable "azure_image_version" {
  type          = string
  default       = "latest"
  description   = "Specify a specific version of an OS to boot from. Defaults to latest. There may be a difference in versions available across regions due to image synchronization latency. To ensure a consistent version across regions set this value to one that is available in all regions where you are deploying."
}

# When creating a VHD the following additional options are required:

# variable "azure_capture_container_name" {
#   type        = string
#   default     = "images"
#   description = "Destination container name. Essentially the directory where your VHD will be organized in Azure."
# }

# variable "azure_capture_name_prefix" {
#   type        = string
#   default     = "packer"
#   description = "VHD prefix. The final artifacts will be named PREFIX-osDisk.UUID and PREFIX-vmTemplate.UUID"
# }

# variable "azure_resource_group_name" {
#   type        = string
#   default     = "spr_infra_rg_packer"
#   description = "Resource group under which the final artifact will be stored."
# }

# variable "azure_storage_account" {
#   type        = string
#   default     = "sprsapacker"
#   description = "Storage account under which the final artifact will be stored."
# }

# When creating a managed image the following additional options are required:

variable "azure_managed_image_name" {
  type          = string
  default       = ""
  description   = "Specify the managed image name where the result of the Packer build will be saved. The image name must not exist ahead of time, and will not be overwritten. If this value is set, the value managed_image_resource_group_name must also be set."
}

variable "azure_resource_group_name" {
  type          = string
  default       = env("TF_VAR_azure_resource_group_name")
  description   = "Specify the managed image resource group name where the result of the Packer build will be saved. The resource group must already exist. If this value is set, the value managed_image_name must also be set."
}

# Azure Share Image Gallery Settings

variable "azure_shared_image_gallery_name" {
  type          = string
  default       = env("TF_VAR_azure_shared_image_gallery_name")
  description   = "Name of the shared image gallery"
}

variable "azure_shared_image_gallery_destination_image_version" {
  type          = string
  default       = "1.0.0"
}

variable "azure_shared_image_gallery_destination_storage_account_type" {
  type          = string
  default       = "Standard_LRS"
}

variable "azure_os_type" {
  type          = string
  default       = "Windows"
}

variable "azure_os_disk_size_gb" {
  type          = number
  default       = null
  description   = "Specify the size of the OS disk in GB (gigabytes). Values of zero or less than zero are ignored."
}

variable "azure_tags" {
  type          = map(string)
  description   = "(map[string]string) - Name/value pair tags to apply to every resource deployed i.e. Resource Group, VM, NIC, VNET, Public IP, KeyVault, etc. The user can define up to 15 tags. Tag names cannot exceed 512 characters, and tag values cannot exceed 256 characters."

  default       = {
    source      = "packer"
  }
}

variable "winrm_username" {
    type        = string
    default     = "packer"
}

variable "ansible_playbook_file" {
  type          = string
  default       = "../../ansible/playbook.yml"
}

variable "ansible_roles_path" {
  type          = string
  default       = "../../ansible/roles"
}

variable "ansible_galaxy_file" {
  type          = string
  default       = "../../ansible/requirements.yml"
}

variable "ansible_groups" {
  type          = list(string)
  default       = ["windows"]
  description   = "The groups into which the Ansible host should be placed. When unspecified, the host is not associated with any groups"
}

variable "ansible_inventory_directory" {
  type          = string
  default       = "../../ansible"
  description   = "The directory in which to place the temporary generated Ansible inventory file."
}

// not used by packer but to get rid off warnigs
// variable "azure_bootstrap_resource_group_name" {
//   type = string
//   default = ""
// }
// variable "azure_bootstrap_storage_account_name" {
//   type = string
//   default = ""
// }
// variable "azure_bootstrap_storage_account_container_name" {
//   type = string
//   default = ""
// }

source "azure-arm" "windows" {
  client_id                 = var.azure_client_id
  client_secret             = var.azure_client_secret
  subscription_id           = var.azure_subscription_id
  tenant_id                 = var.azure_tenant_id

  # When creating a VHD the following additional options are required:
  # capture_container_name  = var.azure_capture_container_name
  # capture_name_prefix     = var.azure_capture_name_prefix
  # resource_group_name     = var.azure_resource_group_name
  # storage_account         = var.azure_storage_account

  # When creating a managed image the following additional options are required:
  managed_image_name                = var.azure_managed_image_name
  managed_image_resource_group_name = var.azure_resource_group_name

  os_type                   = var.azure_os_type
  os_disk_size_gb           = var.azure_os_disk_size_gb
  image_publisher           = var.azure_image_publisher
  image_offer               = var.azure_image_offer
  image_sku                 = var.azure_image_sku
  image_version             = var.azure_image_version

  azure_tags                = var.azure_tags

  location                  = var.azure_location
  vm_size                   = var.azure_vm_size

  shared_image_gallery_destination {
    subscription            = var.azure_subscription_id
    resource_group          = var.azure_resource_group_name
    gallery_name            = var.azure_shared_image_gallery_name
    image_name              = var.azure_managed_image_name
    image_version           = var.azure_shared_image_gallery_destination_image_version
    replication_regions     = [var.azure_location]
    storage_account_type    = var.azure_shared_image_gallery_destination_storage_account_type
  }

  communicator              = "winrm"
  winrm_use_ssl             = true
  winrm_insecure            = true
  winrm_timeout             = "1h"
  winrm_username            = var.winrm_username
}

build {
  sources = ["sources.azure-arm.windows"]

  provisioner "powershell" {
   inline = [
        "  while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
        "  while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }"
   ]
  }

  provisioner "powershell" {
    elevated_user     = build.User
    elevated_password = build.Password
    script            = "../_shared/setup/openssh.ps1"
  }

  provisioner "powershell" {
    elevated_user     = build.User
    elevated_password = build.Password
    script            = "../_shared/setup/snmp.ps1"
  }

  provisioner "ansible" {
    playbook_file           = var.ansible_playbook_file
    user                    = build.User
    use_proxy               = false
    galaxy_file             = var.ansible_galaxy_file
    groups                  = var.ansible_groups
    inventory_directory     = var.ansible_inventory_directory
    roles_path              = var.ansible_roles_path
    ansible_ssh_extra_args  = ["-o IdentitiesOnly=yes", "-o StrictHostKeyChecking=no", "-o UserKnownHostsFile=/dev/null"]
    extra_arguments         = [
      "--extra-vars",
      "ansible_user=${build.User} ansible_password=${build.Password} ansible_become_user=${build.User} ansible_port=22 ansible_shell_type=powershell ansible_become_method=runas ansible_connection=ssh ansible_ssh_retries=30"
    ]
  }

  // provisioner "windows-update" {
  //   search_criteria = "IsInstalled=0"
  //   filters = [
  //     "exclude:$_.Title -like '*Preview*'",
  //     "include:$true",
  //   ]
  //   update_limit = 25
  // }
  //
  // provisioner "windows-restart" {
  //   pause_before = "10s"
  //   max_retries = 3
  //   restart_timeout = "45m"
  // }
  //
  // provisioner "powershell" {
  //  inline = [
  //       "  while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
  //       "  while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }"
  //  ]
  // }

  provisioner "powershell" {
   inline = [
        "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
        "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
   ]
  }

}
