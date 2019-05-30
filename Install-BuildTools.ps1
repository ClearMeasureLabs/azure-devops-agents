function Install-BuildTools {
	param(
		$DatabaseUserName,
		$DatabasePassword,
		$OrganizationUrl,
		$BuildAgentPAT,
		$AgentPool = "Private VS2019",
		$NumOfAgents = 4
	)

	Write-Host "Installing Chocolatey"
	Set-ExecutionPolicy Bypass -Scope Process -Force
	Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

	if(Test-Path("C:\Program Files (x86)\Microsoft Visual Studio\2019")) {
		Write-Host "Visual Studio 2019 is already installed. Skipping installation of VS build tools."
	} else {
		$BuiltToolsUrl = "https://download.visualstudio.microsoft.com/download/pr/077e5fdc-f805-4868-8db6-ecdf820306ee/4bdeb564f89170caabaee46beba35788/vs_buildtools.exe"
		$BuildToolsOut = "C:/temp/vs_buildtools.exe"

		choco install visualstudio2019buildtools --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive --locale en-US"
	}
	
	Write-Host "Installing Packages"
	$Packages = 'git',`
				'visualstudiocode',`
				'sql-server-express',`
				'sql-server-management-studio'
	ForEach ($PackageName in $Packages)
	{ choco install $PackageName -y }
	
	# if SSMS won't open
	# https://dba.stackexchange.com/questions/237086/sql-server-management-studio-18-wont-open-only-splash-screen-pops-up
	# "C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\PrivateAssemblies\Interop\Microsoft.VisualStudio.Shell.Interop.8.0.dll"
	# C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\PublicAssemblies

	# "%ProgramFiles%\Microsoft SQL Server\110\Tools\Binn\sqlcmd.exe" -S . -E -Q "ALTER SERVER ROLE [sysadmin] ADD MEMBER [BUILTIN\Users];"

	# Write-Host "Downloading agent zip file"
	# $url = "https://vstsagentpackage.azureedge.net/agent/2.150.3/vsts-agent-win-x64-2.150.3.zip"
	# $out = "C:/temp/vsts-agent-win-x64-2.150.3.zip"
	# Invoke-WebRequest -Uri $url -OutFile $out
	
	Write-Host "Installing $NumOfAgents build agents"
	For ($i=1; $i -le $NumOfAgents; $i++) {
		$AgentName = "$Env:ComputerName-$i"
		Write-Host "Installing agent $AgentName"
		choco install azure-pipelines-agent --params "'/Directory:c:\agents\agent$i /AgentName:$AgentName /Token:$BuildAgentPAT /Pool:$AgentPool /Url:$OrganizationUrl'" -fy
	}

	# Write-Host "Restarting computer"
	# Restart-Computer
}

# ideas
# make sure sql db username/passwords are set
#future: agents /Work:WorkDirectory set to temp drive for better performance
# don't use choco for build agents?
# should agents machine drives be encrypted?
# default security tools
# auto update schedule/turned on?
# enable mixed mode auth - EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
# remember to restart sql https://stackoverflow.com/questions/12541560/change-sql-server-authentication-mode-using-script