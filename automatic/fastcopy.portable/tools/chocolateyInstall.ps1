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
   url           = 'https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main/FastCopy5.9.0_installer.exe'
   checksum      = 'e0daf618bd4113fe9e4c56eb8faf7111d61b9661756b758d3770ef8c8a09a8e2'
   checksumType  = 'sha256'
   silentArgs    = "/silent /Extract /dir=`"$FolderOfPackage`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

Get-ChildItem -Path $FolderOfPackage -filter 'setup.exe' -Recurse | 
   ForEach-Object { $null = Remove-Item $_.FullName -Force }


