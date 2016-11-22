$packageName='GSView'

$unexe = Join-Path $env:ProgramFiles 'GSView\gsview\uninstgs.exe'
$list = Join-Path (Split-Path $unexe) 'uninstal.txt'

if (Test-Path $unexe) {
   $UninstallArgs = @{
      packageName = $packageName
      fileType = 'exe'
      file = $unexe
      silentArgs = "`"$list`" -quiet"
      validExitCodes = @(0)
   }

   Uninstall-ChocolateyPackage @UninstallArgs
   Remove-Item (Split-Path (Split-Path $unexe)) -Recurse -Force
} else {
   Write-Host "Uninstaller not found!"
}




