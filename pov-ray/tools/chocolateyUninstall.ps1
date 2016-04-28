$UninstallArgs = @{
   packageName = 'pov-ray'
   fileType = 'exe'
   file = 'C:\Program Files\POV-Ray\v3.7\povwin-3.7-uninstall.exe'
   silentArgs = '/S'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs

remove-item "$env:USERPROFILE\..\default\documents\POV-Ray" -Recurse
