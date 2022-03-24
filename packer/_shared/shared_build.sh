#!/bin/bash
set -e

display_usage() {
    echo -e "Invalid parameters."
    echo -e "\nUsage: $0 --image [azure_image_name] --version [azure_image_version] \n"
    echo -e "Example: $0 --image en-windows-2022-small --version 1.0.1 \n"
}

current_dir=$(pwd)
script_name=$(basename "${BASH_SOURCE[0]}")
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_dir_name=$(basename $script_dir)
proj_root="$(dirname $(dirname $script_dir))"

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
    -v|--version)
    VERSION="$2"
    shift # past argument
    shift # past value
    ;;
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
azure_managed_image_name=${IMAGE}
azure_managed_image_version=${VERSION}


if [ -z "$azure_managed_image_name" ]
then
    azure_managed_image_name=$script_dir_name
fi
if [ -z "$azure_managed_image_version" ]
then
    azure_managed_image_version=$(cat ../../VERSION-$azure_managed_image_name | xargs)
fi

#[ ! -f "$azure_managed_image_name.pkrvars.hcl" ] && echo "Error: File $azure_managed_image_name.pkrvars.hcl DOES NOT EXIST" && exit 2

echo -e "-----------------------------------"
echo -e "Packer Azure Managed Image Build"
echo -e "Azure Managed Image: $azure_managed_image_name"
echo -e "Azure Managed Image Version: $azure_managed_image_version"
echo -e "-----------------------------------"

packer init windows.pkr.hcl
packer validate \
-var-file $shared_vars_file \
-var-file ./image.pkrvars.hcl \
-var="azure_managed_image_name=$azure_managed_image_name" \
-var="azure_shared_image_gallery_destination_image_version=$azure_managed_image_version" \
./windows.pkr.hcl

if [ "$WHATIF" != "yes" ]
then
  packer build -force \
  -var-file $shared_vars_file \
  -var-file ./image.pkrvars.hcl \
  -var="azure_managed_image_name=$azure_managed_image_name" \
  -var="azure_shared_image_gallery_destination_image_version=$azure_managed_image_version" \
  ./windows.pkr.hcl
fi

cd $current_dir
