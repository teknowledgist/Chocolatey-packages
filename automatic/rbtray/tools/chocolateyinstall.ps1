$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $PackageFolder -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFiles = Get-ChildItem $toolsDir -filter '*.zip' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 2

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFiles | Where-Object {$_.basename -match '86$'} | Select-Object -ExpandProperty fullname
   FileFullPath64 = $ZipFiles | Where-Object {$_.basename -match '64$'} | Select-Object -ExpandProperty fullname
   Destination    = Join-Path $PackageFolder "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
}
Get-ChocolateyUnzip @UnZipArgs

$ZipFiles | ForEach-Object { Remove-Item $_.fullname -Force }

$pp = Get-PackageParameters

if ($pp['NoHook']) { 
   $Arguments = '--no-hook'
} else {
   $Arguments = ''
}

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\RBTray.lnk'
   TargetPath       = (Get-ChildItem $UnZipArgs.Destination -filter *.exe).fullname
   Arguments        = $Arguments
}
Install-ChocolateyShortcut @ShortcutArgs

if (! $pp['NoAutoStart']) { 
   $ShortcutArgs.ShortcutFilePath = $ShortcutArgs.ShortcutFilePath -replace 'Programs','Programs\Startup'
   Install-ChocolateyShortcut @ShortcutArgs
}
