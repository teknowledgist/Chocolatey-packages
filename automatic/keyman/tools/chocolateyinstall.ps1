$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$FolderOfPackage = Split-Path -Parent $toolsDir
$ZipFile = (Get-ChildItem $toolsDir *.exe).fullname

$UnzipDir = Join-Path $env:TEMP $env:ChocolateyPackageName

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFile
   Destination    = $UnzipDir
}
Get-ChocolateyUnzip @UnZipArgs

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = "$env:ChocolateyPackageName*"
   fileType       = 'msi'
   File           = (Get-ChildItem $UnzipDir -filter "*.msi" -Recurse).FullName
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0)
}
Install-ChocolateyInstallPackage @InstallArgs

Remove-Item $ZipFile -ea 0 -force
