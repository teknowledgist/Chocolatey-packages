$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "v*" | 
               Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   UnzipLocation = "$FolderOfPackage\v$env:ChocolateyPackageVersion"
   Url64bit      = 'https://www.xnview.com/download.php?file=XnViewMP-win-x64.zip'
   Checksum64    = '1e464f651aec6b99699ec21fa3897deca20b1f2d585d8f0e34cec67e30aaabb0'
   ChecksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @InstallArgs

$UnzippedEXEs = Get-ChildItem "$FolderOfPackage\v*" -Filter '*.exe' -Recurse -Exclude 'xnviewmp.exe'
foreach ($exe in $UnzippedEXEs) {
   $null = New-Item "$($exe.fullname).ignore" -Force
}
