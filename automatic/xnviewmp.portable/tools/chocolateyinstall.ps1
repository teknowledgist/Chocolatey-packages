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
   Checksum64    = 'ccf128da6478897b4143bf3bfb66b2a29abac89490992576cf81c5c26de413dc'
   ChecksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @InstallArgs

$UnzippedEXEs = Get-ChildItem "$FolderOfPackage\v*" -Filter '*.exe' -Recurse -Exclude 'xnviewmp.exe'
foreach ($exe in $UnzippedEXEs) {
   $null = New-Item "$($exe.fullname).ignore" -Force
}
