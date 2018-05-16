$ErrorActionPreference = 'Stop'

$Files = Get-ChildItem (Split-Path $MyInvocation.MyCommand.Definition) -Filter '*.msi'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'msi'
   File           = $Files |Where-Object {$_.name -match 'x86'} |Select-Object -ExpandProperty FullName
   File64         = $Files |Where-Object {$_.name -match 'x64'} |Select-Object -ExpandProperty FullName
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs
