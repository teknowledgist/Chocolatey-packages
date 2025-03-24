$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$MSIfiles = Get-ChildItem $toolsDir -Filter '*.msi' |
                  Sort-Object LastWriteTime | 
                  Select-Object -Last 2 -ExpandProperty fullname

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'msi'
   validExitCodes= @(0, 3010, 1641)
}

# 32-bit SQL client applications on 64-bit Windows must ALSO have the 32-bit driver installed
if ((Get-OSArchitectureWidth -Compare 64) -and (-not $Env:chocolateyForceX86)) {
   $BitOptions = @('x86','x64')
} else {
   $BitOptions = @('x86')
}

foreach ($bitness in $BitOptions) {
   $installer = $MSIfiles | Where-Object {$_ -match $bitness}

   $LogPath = "$env:TEMP\$env:chocolateyPackageName-$bitness.$env:chocolateyPackageVersion.MsiInstall.log"
   $InstallArgs.silentArgs = "/qn /norestart /l*v `"$LogPath`" "

   if ($bitness -eq 'x64') { 
      $InstallArgs.File64 = $installer
      Write-Host 'Installing 64-bit PostgreSQL ODBC.' -ForegroundColor Cyan
   } else {
      $InstallArgs.File = $installer
      Write-Host 'Installing 32-bit PostgreSQL ODBC.' -ForegroundColor Cyan
   }
   Install-ChocolateyInstallPackage @InstallArgs
}

$null = Remove-Item $MSIfiles -force
