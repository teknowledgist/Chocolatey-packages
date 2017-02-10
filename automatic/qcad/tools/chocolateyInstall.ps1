$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.16.4-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.16.4-trial-win64-installer.msi'
$checkSum32 = '7f731512e3f8959c949c96e5f1356e005c7df60da0eb3341b0fb9a00b4ebf43f'
$checkSum64 = '4f898acbf0cba0a126d3e72efe4c8ebf802d677e47a1c31bde7e39adecaf8bb3'

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

