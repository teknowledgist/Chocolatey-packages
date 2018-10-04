$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.21.3-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.21.3-trial-win64-installer.msi'
$checkSum32 = 'e867f044171c887c31dacddf0cf1a095a7891bba204e7ab2a520d0e6cbec1d42'
$checkSum64 = 'fa6c6ccd6b0bce7bf2122b91b3570cf61422a99fb57cf91851f53b686fb45660'

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

