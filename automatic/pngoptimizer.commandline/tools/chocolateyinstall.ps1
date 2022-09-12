$ErrorActionPreference = 'Stop'

$BitLevel = Get-ProcessorBits

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

$Destination = Join-Path $FolderOfPackage "v$env:ChocolateyPackageVersion ($BitLevel-bit)"

$Zip32File   = (Get-ChildItem $toolsDir -filter "*x86.zip").FullName
$Zip64File   = (Get-ChildItem $toolsDir -filter "*x64.zip").FullName

$unzipArgs = @{
   PackageName    = $env:chocolateyPackageName
   FileFullPath   = $Zip32File
   FileFullPath64 = $Zip64File
   Destination    = $Destination
}

Get-ChocolateyUnzip @unzipArgs

