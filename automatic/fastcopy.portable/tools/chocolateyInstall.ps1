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
   url           = 'https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main/FastCopy5.7.2_installer.exe'
   checksum      = '96b2061a05e73b86c7891c6ed716dd7f647f003232cd3d3825cbbdbd6e732d53'
   checksumType  = 'sha256'
   silentArgs    = "/silent /Extract /dir=`"$FolderOfPackage`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

Get-ChildItem -Path $FolderOfPackage -filter 'setup.exe' -Recurse | 
   ForEach-Object { $null = Remove-Item $_.FullName -Force }


