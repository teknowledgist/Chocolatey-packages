$AppName = 'POV-Ray'

$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'

$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match $AppName} |
                     Select-Object -ExpandProperty UninstallString

$UninstallArgs = @{
   packageName = $AppName
   fileType = 'exe'
   file = $unexe
   silentArgs = '/S'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs

$PathsToDelete = @(
'HKLM:\Software\POV-Ray'
'HKLM:\Software\Microsoft\Active Setup\Installed Components\POV-Ray'
'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\POV-Ray for Windows v3.7'
Join-Path $env:ProgramFiles 'POV-Ray'
Join-Path $env:USERPROFILE '\..\default\documents\POV-Ray'
Join-Path ([Environment]::GetFolderPath("commondesktopdirectory")) "Launch POV-Ray v3.7.lnk"
)

Foreach ($path in $PathsToDelete) {
   if (Test-Path $path) {
      Remove-Item $path -Recurse -Force
   }
}

