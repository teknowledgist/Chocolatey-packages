$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.19.1-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.19.1-trial-win64-installer.msi'
$checkSum32 = '063c2cd8130e15cfbad852700a72e7c480f3e43ec9165180d88d32832f328c08'
$checkSum64 = '72388f269414386a47118ec66f5f25136c193653dce97ba5ae6cda25c1a9fb46'

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

