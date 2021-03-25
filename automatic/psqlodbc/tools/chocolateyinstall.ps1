$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$ZipFiles = Get-ChildItem $toolsDir -Filter '*.zip' |
                  Sort-Object LastWriteTime | 
                  Select-Object -Last 2

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'msi'
   validExitCodes= @(0, 3010, 1641)
}

# 32-bit SQL client applications on 64-bit Windows must ALSO have the 32-bit driver installed
if ((Get-OSArchitectureWidth -Compare 64) -and (-not $Env:chocolateyForceX86)) {
   $BitOptions = @('-x86','-x64')
} else {
   $BitOptions = @('-x86')
}

foreach ($bitness in $BitOptions) {
   $zipFile = $ZipFiles | Where-Object {$_.name -match $bitness}
   $unzipPath = Join-Path $env:TEMP $ZipFile.basename
   Get-ChocolateyUnzip -FileFullPath $zipFile.FullName -Destination $unzipPath

   $installer = Get-ChildItem $unzipPath -Filter '*.msi'

   $LogPath = "$env:TEMP\$env:chocolateyPackageName$bitness.$env:chocolateyPackageVersion.MsiInstall.log"
   $InstallArgs.silentArgs = "/qn /norestart /l*v `"$LogPath`" "

   if ($bitness -eq '-x64') { 
      $InstallArgs.File64 = $installer.FullName
   } else {
      $InstallArgs.File = $installer.FullName
   }
   Install-ChocolateyInstallPackage @InstallArgs

   $null = Remove-Item $zipFile.FullName -force
}
