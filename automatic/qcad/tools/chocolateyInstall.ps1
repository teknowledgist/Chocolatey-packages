$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.17.1-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.17.1-trial-win64-installer.msi'
$checkSum32 = '5005fd0ad35e55c8d6afa7a2166c9691f54edbdc19ab2e57586b6e684de6c1ee'
$checkSum64 = '995b0529e7c306cc55865c92f4e7675c5600b4744a3eb951823a77c72fd3d6ec'

$InstallArgs = @{
   packageName = $packageName
   installerType = 'msi'
   url = $url32
   url64bit = $url64
   Checksum = $checkSum32
   Checksum64 = $checkSum64
   ChecksumType = 'sha256'
   silentArgs = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

# QCAD is GPLv3, but the binary download comes burdened with with a couple commercial trial plugins.
# Removing a few files eliminates the proprietary pieces.
$TrialFiles = 'qcaddwg.dll','qcadopengl3d','qcadpolygon.dll','qcadproscripts.dll','qcadtriangulation.dll'

foreach ($file in $TrialFiles) {
   Remove-Item (Join-Path $env:ProgramFiles "QCAD\plugins\$file") -Force
}

