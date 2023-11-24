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
   Url           = 'https://download.xnview.com/XnViewMP-win.zip'
   Url64bit      = 'https://download.xnview.com/XnViewMP-win-x64.zip'
   Checksum      = '1fe75ba26f0b482f505387b42dbc65800dc96605171cbe77ddbe34e5cda83ee6'
   Checksum64    = 'ec2bf954de7aad1fe46e454cf7f796291d162d03ca45f65461cc104b1221c360'
   ChecksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @InstallArgs

$UnzippedEXEs = Get-ChildItem "$FolderOfPackage\v*" -Filter '*.exe' -Recurse -Exclude 'xnviewmp.exe'
foreach ($exe in $UnzippedEXEs) {
   $null = New-Item "$($exe.fullname).ignore" -Force
}
