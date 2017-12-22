$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.19.2-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.19.2-trial-win64-installer.msi'
$checkSum32 = 'f4471b1864d2314b35732e13e60fc278655350923d3997de9de4bb849553bb04'
$checkSum64 = 'baae49e5993c90ee856788975ee7bcc7c995e7d7299d3dd60868dbf714cd2153'

$InstallArgs = @{
   packageName = $env:ChocolateyPackageName
   installerType = 'msi'
   url = $url32
   url64bit = $url64
   Checksum = $checkSum32
   Checksum64 = $checkSum64
   ChecksumType = 'sha256'
   silentArgs = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

# QCAD is GPLv3, but the binary download comes burdened with with a couple commercial trial plugins.
# Removing a few files eliminates the proprietary pieces.
$TrialFiles = 'qcaddwg.dll','qcadopengl3d','qcadpolygon.dll','qcadproscripts.dll','qcadtriangulation.dll'

foreach ($file in $TrialFiles) {
   if (test-path (Join-Path $env:ProgramFiles "QCAD\plugins\$file")) {
      Remove-Item (Join-Path $env:ProgramFiles "QCAD\plugins\$file") -Force
   }
}

