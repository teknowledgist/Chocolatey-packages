$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.20.1-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.20.1-trial-win64-installer.msi'
$checkSum32 = '439092ac1dd995f549ae538fd2243a805cd5bd60f22a157c16e46edca726e439'
$checkSum64 = '2f8f5221d29b5108f5fb0d112b080511f56114b93c00bb1e8c50c1b19e3c6696'

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

