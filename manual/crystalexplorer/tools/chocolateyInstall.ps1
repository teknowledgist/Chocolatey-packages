$packageName = 'CrystalExplorer'
$version = '3.1'

if (${Env:ProgramFiles(x86)}) { $DestDir = ${Env:ProgramFiles(x86)} }
else { $DestDir = $Env:ProgramFiles }

$InstallArgs = @{
   PackageName = $packageName
   Url = "http://crystalexplorer.scb.uwa.edu.au/downloads/$packageName$($version)_Windows-Intel-32bit.zip"
   checkSum = '672C47C4E48EB5D10211CA3BEB757C81A1D7CF5A5870D7365453FA72F8655DA9'
   checkSumType = 'sha256'
   UnzipLocation = $DestDir
}
Install-ChocolateyZipPackage @InstallArgs

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([Environment]::GetFolderPath('CommonDesktop')) "$packageName.lnk"
   TargetPath = (Get-ChildItem (join-path $DestDir "$packageName*") -include cry*.exe -Recurse).fullname
}
Install-ChocolateyShortcut @ShortcutArgs
