$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$files = Get-ChildItem $toolsDir -Filter '*.zip' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 2

$unzipArgs = @{
   PackageName    = $env:chocolateyPackageName
   Destination    = "$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion)"
}
if (Get-OSArchitectureWidth -compare 32) {
   $unzipArgs.FileFullPath = $files | Where-Object {$_ -notmatch 'ispy64'} |Select-Object -expand fullname
} else {
   $unzipArgs.FileFullPath64 = $files | Where-Object {$_ -match 'ispy64'} |Select-Object -expand fullname
}
$unzipDir = Get-ChocolateyUnzip @unzipArgs

$installer = Get-ChildItem $unzipDir -filter '*setup*' | Select-Object -ExpandProperty fullname

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   softwareName = "$env:ChocolateyPackageName*"
   fileType     = 'EXE' 
   File         = $installer
   File64       = $installer
   silentArgs   = "/quiet /norestart /log `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).log`""
}

Install-ChocolateyInstallPackage @InstallArgs 
