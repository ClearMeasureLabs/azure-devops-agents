Write-Host "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

$Packages = 'git',`
			'visualstudiocode',`
			'sql-server-express',`
			'sql-server-management-studio'
			
Write-Host "Installing Packages"
ForEach ($PackageName in $Packages)
{ choco install $PackageName -y }

Write-Host "Restarting computer"
Restart-Computer

# Write-Host "Downloading agent zip file"
# $url = "https://vstsagentpackage.azureedge.net/agent/2.150.3/vsts-agent-win-x64-2.150.3.zip"
# $out = "C:/temp/vsts-agent-win-x64-2.150.3.zip"
# Invoke-WebRequest -Uri $url -OutFile $out

$BuildAgentPAT = $Env:BuildAgentPAT
$OrganizationUrl = $Env:OrganizationUrl
$AgentPool = "Private VS2019"

$NumOfAgents = 4
For ($i=1; $i -le $NumOfAgents; $i++) {
    $AgentName = "$Env:ComputerName-$i"
	Write-Host "Installing agent $AgentName"
	choco install azure-pipelines-agent --params "'/Directory:c:\agents\agent$i /AgentName:$AgentName /Token:$BuildAgentPAT /Pool:$AgentPool /Url:$OrganizationUrl'" -fy
}

#future: /Work:WorkDirectory set to temp drive for better performance