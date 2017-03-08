$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName  = 'ShelXTL'
$FileFullPath = '\\Servername\ShareName\ShelXTL\SXTL.zip'
$Destination  = 'c:\SAXI'

Get-ChocolateyUnzip $FileFullPath $Destination -PackageName $packageName

New-Alias icev Install-ChocolateyEnvironmentVariable
icev 'SAXI$ROOT:'    'C:\\SAXI\\'               'Machine'
icev 'SXTL$SYSTEM:'  'C:\\SAXI\\SXTL\\'         'Machine'
icev 'SXTL'          'C:\\SAXI\\SXTL\\SXTL.INI' 'Machine'
icev 'SAXI$USERNAME' '<Enter Name here>'     'Machine'
icev 'SAXI$SITE'     '<Enter Name here>'     'Machine'

Install-ChocolateyPath $Destination 'Machine'
Install-ChocolateyPath 'C:\SAXI\SXTL' 'Machine'

$RegPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\XP, XPREP, XSHELL'
New-Item $RegPath -Value 'C:\\SAXI\\SXTL\\shelxtl.EXE' -Force | Write-Debug
$RegValue = 'C:\\SAXI\\SXTL;C:\\SAXI\\SXTL'
New-ItemProperty -Path $RegPath -Name 'Path' -Value $RegValue -force | Write-Debug

$target   = 'C:\SAXI\SXTL\shelxtl.exe'
$StartShortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\programs\$packageName.lnk"
Install-ChocolateyShortcut -ShortcutFilePath $StartShortcut -TargetPath $target

# If called from "System Center Software Center", find who called it
if ($process = gwmi win32_process -filter "name='scclient.exe'") {
   $username = $process.getowner().user
   if ($username -ne 'SYSTEM') {
      $DeskShortcut = "C:\Users\$username\Desktop\$packageName.lnk"
      Install-ChocolateyShortcut -ShortcutFilePath $DeskShortcut -TargetPath $target
   } else {
      $DeskShortcut = "C:\Users\Default\Desktop\Common Applications\$packageName.lnk"
      Install-ChocolateyShortcut -ShortcutFilePath $DeskShortcut -TargetPath $target
   }
} else {
   $DeskShortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) "$packageName.lnk"
   Install-ChocolateyShortcut -ShortcutFilePath $DeskShortcut -TargetPath $target
}
