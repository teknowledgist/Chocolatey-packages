$ErrorActionPreference = 'Stop'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.exe"
   url          = 'http://downloads.imsidesign.com/ESD/DoubleCAD_XT_v5.exe'
   Checksum     = '8033bd9b706b2f87159c24c15ed7c432b7aa4cfc43356f12ad7066363e9daee9'
   ChecksumType = 'SHA256'
   GetOriginalFileName = $true
}

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = $PackedInstaller
   Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$LogFile = "$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log"
$Transform = Join-path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'PIDKey.mst'

$InstallArgs = @{
   PackageName    = $env:ChocolateyPackageName
   File           = (Get-ChildItem -Path $WorkSpace -Filter 'DoubleCADXT5.msi' -Recurse).FullName
   fileType       = 'msi'
   silentArgs     = "/qn /norestart /l*v `"$LogFile`" ALLUSERS=1 TRANSFORMS=$Transform"
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs
