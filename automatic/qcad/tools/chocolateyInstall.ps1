$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.18.1-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.18.1-trial-win64-installer.msi'
$checkSum32 = '7dfc367be4407df61b3919720bccaa2030ac88a85bcb441f0da0c0a2156af298'
$checkSum64 = '88173e528dad696d1674e47c324723e6debd7b10694d68c394a07a62d5c27275'

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

