# azure-sig

This repository builds Windows Master Images and publishes it to **Azure Compute Gallery** with a single [build command](./build.sh).\
It nicely integrates [Packer](https://www.packer.io/downloads), [Terraform](https://www.terraform.io/downloads.html) and [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). It is hooked into **Github Actions** as CI/CD pipeline.

An additional trick is: Variables from Terrafrom can be reused in Packer, because since Packer 1.5
HCL2 templates are supported and HCL2 is by the way the preferred way to write Packer configurations.
This is why there is a **shared_vars.hcl** file.

**Terraform** is used to fulfill the pre-requesites in Azure.

Terraform creates:

- a resource group
- a shared image gallery
- a shared image definition

**Packer** is used to build the windows master image from a Windows Marketplace image.
Packer is also responsible for versioning the master image and placing it into the share image gallery.

To customize the master image, Packer runs **Ansible** and a specific [ansible playbook](./ansible/playbook.yml).\
The ansible playbook is quite basic, but this is the place to do the real customization of you windows master image.

## How to use this repo

### Pre-requesites

Make sure you have an azure **service principal** account. To create one you can use to following command in the azure command line tool.
Replace your-azure-subscription-id with your real Scription ID. Feel free to also adjust the value of the `--name` attribute.\
Otherwise you can configure a service principal using the Azure Portal. Make sure it has `Contributor` role in your Azure subscription.

```bash
# Login
az login

# Create service principal with Contributor role
az ad sp create-for-rbac \
--name="packer_sp" \
--role="Contributor" \
--scope="/subscriptions/your-azure-subscription-id" \
--sdk-auth \
> az_client_credentials.json
```

Make sure to have a ready to use **storage account** in Azure which is used to store terraform state files. You can manually create it or use [https://github.com/andif888/azure-bootstrap](https://github.com/andif888/azure-bootstrap). You have to specify the storage account in Step 1 into your `.env` file.

### Step 1: Adjust variables

Adjust variables in `.env` file for your Azure environment. There is a [sample.env](./sample.env). Copy it and rename it to `.env`. Documentation on each variable is inside the sample file.

```bash
# Edit the file
cp sample.env .env
```

### Step 2: Make sure to enter you own SSH Public Key into openssh.ps1

Edit the file [./packer/_shared/setup/openssh.ps1](./packer/_shared/setup/openssh.ps1) and replace the existing SSH Public Key with your own.
Otherwise I have access to your machines :-)\
The relevant part is in **Line 24-27**.

```powershell
# Configure SSH public key
$content = @"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRYCV99Ge9LI5Y61t95pkcG7trsDyg/eAHLfTGDMHOGxPDdXSk7wW/OCNsKWeJV20wjayoti2JYB+u4FRvsuyccjRZPlRTsul67QOJEzXfORCHD4EYDTR45l0n08zkUPRfs70yo5L5YG9HYgVr6+EK/F8fFReFDvhZwy8LW/hJSeyVCWlbszmuQYcHRmCkWBeAgEiPqx0Mx17txjw9p4RK/LbweYxN4fGu5Nh2Dz9uSBi2IfGds3rPcQvjnJBzt2GEDoZXdXgwXl4T5B0xEDJVMqS/Q+gArcL82cGsY7zpoWpKfOuVy88GD1qaHZgMvQ3LQRyxVysfhxvzSXRX0eF8518/8hGNLxmSak3dZyi5J2ojPdaYzOxtn4JTDFUKNCBQNLHJZCBl1J7HvilTnwQDbgWm0UoFB0dWG3fX4u1wGm11L9sX0kzQ+NZH2Q+9HVX+1vJWZJuNjlhogcsmXG1hecLZPD7WFl82nbmN7zBQwHtUbjUNERMHvXuUvjPnkjJh0avZVtUCRupJhNgyhTR0cWpzffmA2nzdQpIn6z93zVrgefwIpfr+Grk/XQTOXisIfYz/3sofQ9a2hTdPTj0UwKzULB0Pvsf/aYvVEG7zC0sRfPG/pj5cGeFnOB3Ar2/jd58EB7mLzm45MZ+ztSNRW+Eg32Lq1WgOJZ15TiH/pQ== prianto_autodeploy_id_2018
"@
```

If you don't need SSH Public Key Authentication, you can remove the whole part between Line 24 and 40.

### Step 3: Build

Run the [build.sh](./build.sh). Make sure you source the `.env` file before.

[build.sh](./build.sh) runs the [build.sh](./terraform/_image_gallery/build.sh) in the [./terrform/_image_gallery](./terraform/_image_gallery) directory to create the **shared image gallery**.

[build.sh](./build.sh) runs the [build.sh](./terraform/en-windows-2022-small/build.sh) in **each subfolder** of [./terraform](./terraform/)  which does not start with `.*` and not with `_*` to create the **gallery image definition**.

After that it runs the [build.sh](./packer/en-windows-2022-small/build.sh) in **each subfolder** of [./packer](./packer) directory to build a new **gallery image version**.
The version information for gallery image versions is used from **VERSION-*** files.

```bash
source .env
./build.sh
```

----

## Cleanup

To cleanup and delete everything in azure.

```bash
source .env
./destroy.sh
```

----

## Github Actions

This repo is integrated with **Github Actions**.  
Before pushing your repo changes to Github, make sure to create an **repository secret** named `envfile` in Github. Copy the complete contents of your`.env` file into this repository secret.   
Checkout: [How to create envfile as Github secret](./docs/how_to_create_envfile_as_github_secret.md)

There a 2 Github Action workflows in [.github/workflows](./.github/workflows) to manage the the **Azure Compute Image Gallery** and **Image Definitions**.

- **[sig](./.github/workflows/sig.yml)** builds the Azure Compute Image Gallery and Gallery Image Definition
- **[sig_destroy](./.github/workflows/sig.yml)** destroys everything

The remaining Github Actions named `packer-*` are responsible for building concrete **Gallery Image Versions**.

- [packer-de-windows-10-avd](./.github/workflows/packer-de-windows-10-avd.yml)
- [packer-de-windows-11-avd](./.github/workflows/packer-de-windows-11-avd.yml)
- [packer-de-windows-2019-small](./.github/workflows/packer-de-windows-2019-small.yml)
- [packer-de-windows-2022-small](./.github/workflows/packer-de-windows-2022-small.yml)
- [packer-en-windows-10-avd](./.github/workflows/packer-en-windows-10-avd.yml)
- [packer-en-windows-11-avd](./.github/workflows/packer-en-windows-11-avd.yml)
- [packer-en-windows-2019-small](./.github/workflows/packer-en-windows-2019-small.yml)
- [packer-en-windows-2022-small](./.github/workflows/packer-en-windows-2022-small.yml)

### sig

This workflow runs, when there are changes in any file below **[terraform](./terraform)** folder.  
This workflow can also be started manually using `workflow_dispatch`.

### sig_destroy

This workflow is only started manually using `workflow_dispatch`. You should only run this workflow if you intend to destroy everything.

### packer-*

Those workflows run, when there are changes in any file below the corresponding **[packer](./packer)** folder and ansible file.
This workflow can also be started manually using `workflow_dispatch`. It automatically increments the `patch` version number in **VERSION-*** file.

----

## Adding an additional Gallery Image

To add an addition gallery image you need 3 things:

- azure gallery image definition in terraform
- image build in packer
- integrate into github actions

ideally you create a **new branch** in your git repo, push the changes and create a **pull request** at the end.

```bash
git switch -c feature/windows-11-avd
```

### azure gallery image definition in terraform

Create a new folder under [terraform](./terraform) and give it a name. This name is the resulting name for your gallery image definition.

```bash
mkdir -p ./terraform/windows-11-avd
```

Link the following files from the [terraform/_shared](./terraform/_shared) directory into this new folder.

```bash
# cd into the new folder
cd ./terraform/windows-11-avd

# link shared_build.sh
ln -s ../_shared/shared_build.sh build.sh

# link shared_destroy.sh
ln -s ../_shared/shared_destroy.sh destroy.sh

# link shared_image.tf
ln -s ../_shared/shared_image.tf main.tf

# link shared_provider.tf
ln -s ../_shared/shared_provider.tf provider.tf

# link shared_image.tf
ln -s ../_shared/shared_variables.tf variables.tf
```

Create a new file named `image.auto.tfvars` in this folder

```bash
touch image.auto.tfvars
```

define the setting for the gallery image definition in the `image.auto.tfvars`.  
Example settings:

```tf
# Resulting publisher name of the managed image in the share image gallery
azure_managed_image_publisher = "PRWindowsDesktop"

# Resulting offer name of the managed image in the share image gallery
azure_managed_image_offer = "windows-11-avd"

# Resulting sku of the managed image in the share image gallery
azure_managed_image_sku = "win11-21h2-avd"

# The generation of HyperV that the Virtual Machine used to create the Shared Image is based on.
# Possible values are V1 and V2. Defaults to V1. Window 11 Marketplace images are V2.
azure_managed_image_hyper_v_generation = "V2"
```

### image build in packer

Create a new folder under [packer](./packer) an give it a name. This name is the resulting name for your gallery image definition.

```bash
mkdir -p ./packer/windows-11-avd
```

Link the following files from the [packer/_shared](./packer/_shared) directory into this new folder.

```bash
# cd into the new folder
cd ./packer/windows-11-avd

# link shared_build.sh
ln -s ../_shared/shared_build.sh build.sh

# link shared_windows.pkr.hcl
ln -s ../_shared/shared_windows.pkr.hcl windows.pkr.hcl
```

Create a new file named `image.pkrvars.hcl` in this folder

```bash
touch image.pkrvars.hcl
```

define the setting for the packer build in the `image.pkrvars.hcl`.  
Example settings:

```hcl
# Name of the publisher to use for your base image (source image) (Azure Marketplace Images only).
azure_image_publisher           = "MicrosoftWindowsDesktop"

# Name of the publisher's offer to use for your base image (source image) (Azure Marketplace Images only).
azure_image_offer               = "Windows-11"

# SKU of the image offer to use for your base image (source image) (Azure Marketplace Images only).
azure_image_sku                 = "win11-21h2-avd"

# Storage account of the managed image in the shared image gallery
azure_shared_image_gallery_destination_storage_account_type = "Standard_LRS"

# Size of the VM used for building. This can be changed when you deploy a VM
azure_vm_size                   = "Standard_D2ds_v5"

# The main ansible playbook which packer executes
ansible_playbook_file           = "../../ansible/playbook.yml"

```

#### test a local build

```bash
source .env
./build.sh
```
**or** only an individual build

```bash
source .env
cd ./terraform/windows-11-avd
./build.sh
```

```bash
source .env
cd ./packer/windows-11-avd
./build.sh
```

### integrate into github actions

#### Add packer workflow

Use the existing [packer-en-windows-2022-small.yml](./.github/workflows/packer-en-windows-2022-small.yml) and make a copy of it.

```bash
cp ./.github/workflows/packer-en-windows-2022-small.yml ./.github/workflows/packer-windows-11-avd.yml
```

Adjust the name in **line 3** to:  
Example:
```yaml
name: packer-windows-11-avd
```

Adjust the var in **line 33** to:  
Example:
```yaml
      PKR_VAR_azure_managed_image_name: windows-11-avd
```

#### Adjust sig workflow

copy **line 104-191** and paste them at the end of the file.

Adjust the following lines for the new gallery image:

Adjust **line 104-116**, so that the values match your new gallery image name (foldername)
```yaml
##############################
# Job: windows_11_avd:
##############################
  windows_11_avd:
    name: windows-11-avd
    needs: terraform_image_gallery
    runs-on: ubuntu-latest
    env:
      TF_VAR_azure_managed_image_name: windows-11-avd
      tf_actions_working_dir: 'terraform/windows-11-avd'
    defaults:
      run:
        working-directory: ${{ env.tf_actions_working_dir }}
```

### Push changes to Github

After you have created a **new branch** in git and made all your changes, you **stage, commit and push** your changes using:

```bash
git add .
git commit -m "added build for window-11-avd"
git push origin feature/windows-11-avd
```

After that you create a **pull request** and **merge** the changes into **master**.

###### tag: `test pull request`
