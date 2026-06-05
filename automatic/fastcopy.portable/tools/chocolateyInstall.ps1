$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter 'FastCopy*' | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'FastCopy' 
   fileType      = 'EXE'
   url           = 'https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main/FastCopy5.11.3_installer.exe'
   checksum      = '723d3e50f391dbfc041efec9de7cadee9cc1d63feba5c1ebf461e662401965cf'
   checksumType  = 'sha256'
   silentArgs    = "/silent /Extract /dir=`"$FolderOfPackage`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

Get-ChildItem -Path $FolderOfPackage -filter 'setup.exe' -Recurse | 
   ForEach-Object { $null = Remove-Item $_.FullName -Force }


