$ErrorActionPreference = 'Stop'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipFiles = Get-ChildItem $toolsDir -filter *.zip | 
               Sort-Object LastWriteTime | Select-Object -ExpandProperty FullName -Last 2

$UnzipArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFiles | Where-Object {$_ -notmatch '64'}
   FileFullPath64 = $ZipFiles | Where-Object {$_ -match '64'}
   Destination    = $env:ChocolateyPackageFolder
}
Get-ChocolateyUnzip @UnzipArgs
$ZipFiles | ForEach-Object {Remove-Item $_ -Force}

$Linkname = 'Reminder.lnk'
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$SCArgs = @{
   shortcutFilePath = Join-Path $StartPrograms $Linkname
   targetPath       = (Get-ChildItem $env:ChocolateyPackageFolder -filter '*.exe').fullname
   WorkingDirectory = '%APPDATA%'
}
Install-ChocolateyShortcut @SCArgs

$exes = Get-ChildItem $env:ChocolateyPackageFolder -filter *.exe |Select-Object -ExpandProperty fullname
foreach ($exe in $exes) {
   $null = New-Item "$exe.ignore" -Type file -Force
}
