$AdminPassword = ConvertTo-SecureString  $Env:AdminPassword -AsPlainText -Force


#New-AzureRmResourceGroupDeployment -ResourceGroupName Test -TemplateFile ./template/template.json -TemplateParameterFile ./template/parameters.json -adminPassword (ConvertTo-SecureString -String [password here] -AsPlainText -Force)
New-AzureRmResourceGroupDeployment -ResourceGroupName Test -TemplateFile ./template/template.json -TemplateParameterFile ./template/parameters.json -adminPassword $AdminPassword