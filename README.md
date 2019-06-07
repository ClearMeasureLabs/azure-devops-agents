# Introduction 
This project contains an ARM template to build an Azure DevOps pipeline self hosted agent VM.

# Steps to Create a Pipeline Agent VM
1. Create a PAT in Azure DevOps.
1. Create an Azure VM using the ARM template azure-devops-pipeline-vm.
    * Option 1 - Create a build pipeline in Azure DevOps. Import the file '' into Azure DevOps.
    * Option 2 - Run the DeployBuildVM.ps1 on the command line and target an existing resource group.
1. Remote into the Azure VM.
    * Log into the Azure portal and find the IP Address of the VM.
    * RDP into the VM using the username and password you supplied when creating the VM.
1. Copy the InstallBuildTools.ps1 to the server
1. Run the InstallBuildTools.ps1 file