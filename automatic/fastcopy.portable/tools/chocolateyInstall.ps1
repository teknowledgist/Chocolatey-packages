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
   url           = 'https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main/FastCopy5.4.3_installer.exe'
   checksum      = 'b309e5c857e950d72228313ca991134c5a9c7fc723e7a4e9c0e34b4027e6f939'
   checksumType  = 'sha256'
   silentArgs    = "/silent /Extract /dir=`"$FolderOfPackage`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

Get-ChildItem -Path $FolderOfPackage -filter 'setup.exe' -Recurse | 
   ForEach-Object { $null = Remove-Item $_.FullName -Force }


