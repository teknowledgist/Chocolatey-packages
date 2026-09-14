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
   url           = 'https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main/FastCopy5.12.0_installer.exe'
   checksum      = '14ccc9d2ebbdfbcbcf0c6e4004773d12bb98de197a572959473a2d9d3b000e3d'
   checksumType  = 'sha256'
   silentArgs    = "/silent /Extract /dir=`"$FolderOfPackage`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

Get-ChildItem -Path $FolderOfPackage -filter 'setup.exe' -Recurse | 
   ForEach-Object { $null = Remove-Item $_.FullName -Force }


