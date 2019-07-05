$ErrorActionPreference = 'Stop' 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe').FullName

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $fileLocation
   silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
New-Item "$fileLocation.ignore" -Type file -Force | Out-Null
