$ResourceGroup = Test
$AdminPassword = ConvertTo-SecureString  $Env:AdminPassword -AsPlainText -Force

New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroup  -TemplateFile ./azure-devops-pipeline-vm.json -TemplateParameterFile ./azure-devops-pipeline-vm.parameters.json `
    -adminUsername buildadmin`
    -adminPassword $AdminPassword`
    -virtualMachineName build-vm001`
    -location southcentralus