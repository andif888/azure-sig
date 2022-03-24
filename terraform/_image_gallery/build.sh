#!/bin/bash
set -e
current_dir=$(pwd)
script_name=$(basename "${BASH_SOURCE[0]}")
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_dir_name=$(basename $script_dir)

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -w|--whatif)
    WHATIF="yes"
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

cd $script_dir

shared_vars_file=../../shared_vars.hcl

terraform init \
-backend-config="resource_group_name=${TF_VAR_azure_bootstrap_resource_group_name}" \
-backend-config="storage_account_name=${TF_VAR_azure_bootstrap_storage_account_name}" \
-backend-config="container_name=${TF_VAR_azure_bootstrap_storage_account_container_name}" \
-backend-config="key=${TF_VAR_azure_shared_image_gallery_name}.tfstate"
terraform validate
terraform plan -var-file $shared_vars_file -input=false -out=planfile

if [ "$WHATIF" != "yes" ]
then
  terraform apply -auto-approve planfile
fi

cd $current_dir
