#!/bin/bash
set -e
shared_vars_file=../../shared_vars.hcl
azure_bootstrap_resource_group_name=$(cat $shared_vars_file | grep "azure_bootstrap_resource_group_name" | cut -d'=' -f2 | tr -d '"' | xargs)
azure_bootstrap_storage_account_name=$(cat $shared_vars_file | grep "azure_bootstrap_storage_account_name" | cut -d'=' -f2 | tr -d '"' | xargs)
azure_bootstrap_storage_account_container_name=$(cat $shared_vars_file | grep "azure_bootstrap_storage_account_container_name" | cut -d'=' -f2 | tr -d '"' | xargs)
azure_gallery_name=$(cat $shared_vars_file | grep "azure_shared_image_gallery_name" | cut -d'=' -f2 | tr -d '"' | xargs)
echo "$azure_bootstrap_resource_group_name"
echo "$azure_bootstrap_storage_account_name"
echo "$azure_bootstrap_storage_account_container_name"
echo "$azure_gallery_name"

terraform init \
-backend-config="resource_group_name=${azure_bootstrap_resource_group_name}" \
-backend-config="storage_account_name=${azure_bootstrap_storage_account_name}" \
-backend-config="container_name=${azure_bootstrap_storage_account_container_name}" \
-backend-config="key=${azure_gallery_name}.tfstate"
terraform validate
terraform plan -var-file $shared_vars_file -input=false -out=planfile
terraform apply -auto-approve planfile
