#!/bin/bash
set -e
shopt -s extglob

current_dir=$(pwd)
script_name=$(basename "${BASH_SOURCE[0]}")
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
environment=$(basename $script_dir)

build_path_terraform=$script_dir/terraform
build_path_packer=$script_dir/packer

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
echo "build_path_packer:"
echo $build_path_packer
echo "-------"
echo "build_path_terraform:"
echo $build_path_terraform
echo "-------"
echo "current_dir:"
echo $current_dir
echo "-------"

# azure_managed_image_version=$(cat ./VERSION | xargs)


echo "creating image gallery"
cd $build_path_terraform/_image_gallery && ./build.sh

for d in $build_path_terraform/!(_*|.*)/
do
    azure_managed_image_name=$(basename "$d")
    echo $azure_managed_image_name

    cd $build_path_terraform/$azure_managed_image_name && ./build.sh &
done
wait

# for d in $build_path_packer/!(_*|.*)/
# do
#     azure_managed_image_name=$(basename "$d")
#     echo $azure_managed_image_name
#
#     cd $build_path_packer/$azure_managed_image_name && ./build.sh &
# done
# wait

cd $current_dir
