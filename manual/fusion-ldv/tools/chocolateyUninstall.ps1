# Find where Fusion-LDV installed itself (no registry entry!)
$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu'
$SMlink = Get-ChildItem $StartMenu -Filter 'Fusion.lnk' -Recurse
if ($SMlink) {
   $lnk = (new-object -com wscript.shell).createShortcut($SMlink.FullName)

   # Find the uninstaller
   $Unexe = Get-ChildItem (Split-Path $lnk.targetPath) -Filter Uninstall.exe

   $UninstallArgs = @{
      packageName = 'fusion-ldv'
      fileType = 'exe'
      file = $unexe.FullName
      silentArgs = '/S'
      validExitCodes = @(0)
   }

   Uninstall-ChocolateyPackage @UninstallArgs
   remove-item $smlink.directory.fullname -Recurse -Force
} else {
   Throw "Fusion-LDV install not found!"
}




