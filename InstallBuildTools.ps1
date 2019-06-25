[CmdletBinding()]
param(
	$DatabaseUserName,
	$DatabasePassword,
	$OrganizationUrl,
	$BuildAgentPAT,
	$AgentPool = "Private VS2019",
	$NumOfAgents = 4
)

whoami

Write-Host "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

if(Test-Path("C:\Program Files (x86)\Microsoft Visual Studio\2019")) {
	Write-Host "Visual Studio 2019 products detected. Skipping installing VS 2019 Build Tools."
} else {
	Write-Host "Installing VS Build Tools"

	choco install visualstudio2019buildtools --package-parameters "--allWorkloads --includeRecommended --includeOptional --quiet --norestart --locale en-US" -y
}

Write-Host "Installing Packages"
$Packages = 'azurepowershell',`
			'googlechrome',`
			'git',`
			'visualstudiocode',`
			'sql-server-2017',`
			'sql-server-management-studio'
ForEach ($PackageName in $Packages)
{ choco install $PackageName -y }

# if SSMS won't open
# https://dba.stackexchange.com/questions/237086/sql-server-management-studio-18-wont-open-only-splash-screen-pops-up
# cp "C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\PrivateAssemblies\Interop\Microsoft.VisualStudio.Shell.Interop.8.0.dll" "C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\PublicAssemblies"

Write-Host "Installing $NumOfAgents pipeline agents"
For ($i=1; $i -le $NumOfAgents; $i++) {
	$AgentName = "$Env:ComputerName-$i"
	Write-Host "Installing agent $AgentName"
	# calling force on install as workaround to install multiple agents
	choco install azure-pipelines-agent --params "'/Directory:c:\agents\a$i /WorkDirectory:d:\work\a$i /AgentName:$AgentName /Token:$BuildAgentPAT /Pool:$AgentPool /Url:$OrganizationUrl'" -fy
}

# Write-Host "Restarting computer"
# Restart-Computer


# ideas
# make sure sql db username/passwords are set
#future: agents /Work:WorkDirectory set to temp drive for better performance
# don't use choco for build agents?
# should agents machine drives be encrypted?
# default security tools
# auto update schedule/turned on?
# enable mixed mode auth - EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
# remember to restart sql https://stackoverflow.com/questions/12541560/change-sql-server-authentication-mode-using-script
# chocolatey throttling - based on ip
