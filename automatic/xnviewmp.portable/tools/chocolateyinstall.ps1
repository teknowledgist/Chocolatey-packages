$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$FolderOfPackage = Split-Path -Parent $toolsDir

$Zips = Get-ChildItem $toolsDir -Filter '*.zip' | Sort-Object LastWriteTime | 
            Select-Object -Last 2 -ExpandProperty FullName

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" | 
               Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   Destination    = "$FolderOfPackage\$env:ChocolateyPackageName_$env:ChocolateyPackageVersion"
   FileFullPath   = $Zips | Where-Object {$_ -notmatch 'x64'}
   FileFullPath64 = $Zips | Where-Object {$_ -match 'x64'}
}

Install-ChocolateyInstallPackage @InstallArgs

foreach ($file in $Zips) {
   Remove-Item $file -ea 0 -force
}
