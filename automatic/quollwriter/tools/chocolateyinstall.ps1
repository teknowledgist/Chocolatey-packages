$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$Installer = (Get-ChildItem $toolsDir -filter '*.exe').FullName

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'exe'
   File           = $Installer
   silentArgs    = '-q -Dinstall4j.keepLog=true'
   validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs 

