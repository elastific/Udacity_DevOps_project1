# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository, or copy the folder into a drive on your machine

2. Create your infrastructure as code, using the instructions provided below

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
using azure CLI comands:
1- open WindowsPoweshell or Bash depending on your OS
2- use `az` login to log into your Azure subscription

3- go to the directory you have stored the files (main.tf, vars.tf. server.json, etc.) using `cd` command
4- first we want to Deploy a `policy` that ensures all indexed resources in our subscription have tags and deny deployment if they do not
5- We now try to use Packer to create a server image. This could be done using `server.json` file provided here
6- to deploy the infrastructure, we will need to do the followings in that order:
    - Run `packer build` on the Packer template provided, this will deploy the image, only then can we:
    - Run `terraform plan -out solution.plan`, this step will save the plan file with the name `solution.plan`. Note that we have 2 files associated with Terraform (`main.tf` and `vars.tf`)
    - In case you need to configure the number of virtual machines or location, go to `vars.tf` and change the default value for variable `count_` or `location`.
   
### Output
as expected, the steps above will create our infrastructure on Azure. you can go to Azure portal and see these resources deployed with your desired specifications.


