# Azure Bicep Deployment Instructions

This document outlines the steps required to deploy your Bicep template to create a Virtual Machine in Azure.

## 1. Log in to Azure

Open your Azure Cloud Shell or your local terminal and run:

```bash
az login
```

This command will authenticate you with your Azure account.

## 2. Create a Resource Group (if needed)
If you don't already have a resource group, create one by running:

```bash
az group create --name YourResourceGroup --location YourLocation
```
Replace YourResourceGroup with the desired name for your resource group and YourLocation with your preferred Azure region (e.g., eastus, centralus).

## 3. Deploy the Bicep Template
Deploy your Bicep template (createVM.bicep) by executing the following command:

```bash
az deployment group create --resource-group YourResourceGroup --template-file createVM.bicep --parameters adminPassword="YourPassword" adminUsername="YourUsername" vmName="YourVMName"
```
Replace the parameter values as needed:

- adminPassword: The admin password for the VM.

- adminUsername: The admin username for the VM.

- vmName: The name of the virtual machine (this also sets the computer name).

## Summary
The above steps will log you into Azure, ensure that your resource group exists, and then deploy all the resources defined in your Bicep template.





