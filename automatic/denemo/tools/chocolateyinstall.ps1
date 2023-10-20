$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous, unzipped "installs"
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$Destination = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   Url            = 'http://denemo.org/~rshann/denemo-2.6.0.zip'
   Checksum       = '9b4f97ca7bb78c946263c98cee68c9aef5a2d004b2f9fa08e5f4957c60eacc1c'
   checksumType   = 'sha256'
   UnzipLocation  = $Destination
}
Install-ChocolateyZipPackage @UnZipArgs

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\Denemo.lnk'
   TargetPath       = (Get-ChildItem $Destination -filter 'Denemo.bat' -Recurse).FullName
}
Install-ChocolateyShortcut @ShortcutArgs

$EXEs = Get-ChildItem $Destination *.exe -Recurse
foreach ($exe in $exes) {
   $null = New-Item "$($exe.fullname).ignore" -Type file -Force
}
