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
   Checksum      = '28696d6cefb8689229f1b59e33e2cfe0814dd28001f3d5dfb0c3b56136a2c7cc'
   Checksum64    = 'd7c37e6b659294cff54de9b4187db4f0170caf99e37148de81baff9f81bd2ee4'
   ChecksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @InstallArgs

$UnzippedEXEs = Get-ChildItem "$FolderOfPackage\v*" -Filter '*.exe' -Recurse -Exclude 'xnviewmp.exe'
foreach ($exe in $UnzippedEXEs) {
   $null = New-Item "$($exe.fullname).ignore" -Force
}
