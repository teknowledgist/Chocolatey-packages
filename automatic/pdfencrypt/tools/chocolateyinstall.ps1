$ErrorActionPreference = 'Stop' 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -filter '*.exe' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $fileLocation
   silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /ALLUSERS /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes = @(0)
}

Get-Process -Name $env:ChocolateyPackageName -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Install-ChocolateyInstallPackage @InstallArgs
Remove-Item $fileLocation -ea 0 -force
