#!/bin/bash
set -e

display_usage() {
    echo -e "Invalid parameters."
    echo -e "\nUsage: $0 --image [azure_image_name] \n"
    echo -e "Example: $0 --image en-windows-2022-small \n"
}

current_dir=$(pwd)
script_name=$(basename "${BASH_SOURCE[0]}")
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_dir_name=$(basename $script_dir)
proj_root="$(dirname $(dirname $script_dir))"

echo "current_dir:"
echo $current_dir
echo "-------"
echo "script_name:"
echo $script_name
echo "-------"
echo "script_dir:"
echo $script_dir
echo "-------"
echo "script_dir_name:"
echo $script_dir_name
echo "-------"
echo "proj_root:"
echo $proj_root

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -i|--image)
    IMAGE="$2"
    shift # past argument
    shift # past value
    ;;
    -g|--gallery)
    GALLERY="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

shared_vars_file=../../shared_vars.hcl
azure_bootstrap_resource_group_name=$(cat $shared_vars_file | grep "azure_bootstrap_resource_group_name" | cut -d'=' -f2 | tr -d '"' | xargs)
azure_bootstrap_storage_account_name=$(cat $shared_vars_file | grep "azure_bootstrap_storage_account_name" | cut -d'=' -f2 | tr -d '"' | xargs)
azure_bootstrap_storage_account_container_name=$(cat $shared_vars_file | grep "azure_bootstrap_storage_account_container_name" | cut -d'=' -f2 | tr -d '"' | xargs)
azure_gallery_name=$(cat $shared_vars_file | grep "azure_shared_image_gallery_name" | cut -d'=' -f2 | tr -d '"' | xargs)
echo "$azure_bootstrap_resource_group_name"
echo "$azure_bootstrap_storage_account_name"
echo "$azure_bootstrap_storage_account_container_name"
echo "$azure_gallery_name"

azure_managed_image_name=${IMAGE}

if [ -z "$azure_managed_image_name" ]
then
    #display_usage
    azure_managed_image_name=$script_dir_name
    #exit 1
fi

azure_gallery_name=${GALLERY}

if [ -z "$azure_gallery_name" ]
then
  azure_gallery_name=$(cat $shared_vars_file | grep "azure_shared_image_gallery_name" | cut -d'=' -f2 | tr -d '"' | xargs)
  echo "$azure_gallery_name"
fi

echo -e "-----------------------------------"
echo -e "Terrafrom Azure Managed Image Build"
echo -e "Azure Managed Image: $azure_managed_image_name"
echo -e "-----------------------------------"

terraform init \
-backend-config="resource_group_name=${azure_bootstrap_resource_group_name}" \
-backend-config="storage_account_name=${azure_bootstrap_storage_account_name}" \
-backend-config="container_name=${azure_bootstrap_storage_account_container_name}" \
-backend-config="key=${azure_gallery_name}_${azure_managed_image_name}.tfstate"
terraform validate
terraform plan -var-file $shared_vars_file -var="azure_managed_image_name=$azure_managed_image_name" -input=false -out=planfile
terraform apply -auto-approve planfile
