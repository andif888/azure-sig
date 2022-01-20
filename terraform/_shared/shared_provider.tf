provider "azurerm" {
  features {}
  // provided in .env
  // subscription_id           = var.azure_subscription_id
  // client_id                 = var.azure_client_id
  // client_secret             = var.azure_client_secret
  // tenant_id                 = var.azure_tenant_id
}

terraform {
  backend "azurerm" {
    // provided on commandline:
    // terraform init -backend-config="key=filename.tfstate"
    // resource_group_name  = "plyg02_rg"
    // storage_account_name = "plyg02std"
    // container_name       = "terraformstates"
    // key                = "filename.tfstate"
    // provided in .env as ARM_ACCESS_KEY
    // access_key         = "abcdefghijklmnopqrstuvwxyz0123456789..."
  }
}
