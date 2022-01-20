#!/bin/bash
set -e
shopt -s extglob

current_dir=$(pwd)
script_name=$(basename "${BASH_SOURCE[0]}")
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
environment=$(basename $script_dir)

build_path_terraform=$script_dir/terraform

echo "-------"
echo "environment:"
echo $environment
echo "-------"
echo "script_name:"
echo $script_name
echo "-------"
echo "script_dir:"
echo $script_dir
echo "-------"
echo "build_path_terraform:"
echo $build_path_terraform
echo "-------"
echo "current_dir:"
echo $current_dir
echo "-------"

#### Delete Azure Image Versions #########

azure_gallery_name=$(cat shared_vars.hcl | grep "azure_shared_image_gallery_name" | cut -d'=' -f2 | tr -d '"' | xargs)
azure_resource_group=$(cat shared_vars.hcl | grep "azure_resource_group_name" | cut -d'=' -f2 | tr -d '"' | xargs)

echo "azure_gallery_name: $azure_gallery_name"
echo "azure_resource_group: $azure_resource_group"

az login --service-principal --username $ARM_CLIENT_ID --p=$ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID --output none
az account set --subscription $ARM_SUBSCRIPTION_ID

for d in $build_path_terraform/!(_*|.*)/
do
    azure_managed_image_name=$(basename "$d")
    echo $azure_managed_image_name

    for i in `az sig image-version list --gallery-image-definition $azure_managed_image_name --gallery-name $azure_gallery_name --resource-group $azure_resource_group -o tsv --query '[].name'`
    do
      echo "purging image-versions: $i" && \
      $(az sig image-version delete \
      --gallery-image-definition $azure_managed_image_name \
      --gallery-image-version $i \
      --gallery-name $azure_gallery_name \
      --resource-group $azure_resource_group)
    done

    # Delete Image
    echo "deleting managed image: $azure_managed_image_name"
    az image delete --name $azure_managed_image_name --resource-group $azure_resource_group

    # Delete Gallery Image Definition
    echo "deleting gallery image definition: $azure_managed_image_name"
    cd $build_path_terraform/$azure_managed_image_name
    ./destroy.sh -i $azure_managed_image_name
done

echo "deleting gallery"
cd $build_path_terraform/_image_gallery
./destroy.sh

cd $current_dir
