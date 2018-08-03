$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.21.2-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.21.2-trial-win64-installer.msi'
$checkSum32 = '2302d4ff37e603e7da06b3db8637d7f3a70b55910c9635c02f07dbc913594fe6'
$checkSum64 = '381684b1e92c9aec1e56711ff7ed9fbb7f2b5f4a85f2dcbfe4b1e52fb49dd068'

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

