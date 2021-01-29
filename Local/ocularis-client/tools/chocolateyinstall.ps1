$ErrorActionPreference = 'Stop'

# Installer requires MSMQ Server Core to successfully install silently
Enable-WindowsOptionalFeature -Online -FeatureName MSMQ-Server -All -NoRestart

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerFile = (Get-ChildItem -Path $toolsDir -Filter "*.exe").FullName

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   File64         = "$InstallerFile"
   silentArgs     = '/s'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

Remove-Item $InstallerFile -ea 0 -force

