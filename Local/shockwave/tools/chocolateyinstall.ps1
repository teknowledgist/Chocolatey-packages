# First, uninstall all EXE installed versions
[array]$keys = Get-UninstallRegistryKey -SoftwareName 'Adobe Shockwave Player*'

Foreach ($Key in $Keys) {
   if ($Key.UninstallString -notmatch 'msiexec') {
      $Uninstall = $Key.UninstallString
      Start-Process $Uninstall -wait -ArgumentList '/S'
   }
}

$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.msi').FullName

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'msi' 
  file          = $fileLocation
   softwareName  = "Adobe Shockwave Player*"
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
}

Install-ChocolateyInstallPackage @packageArgs

