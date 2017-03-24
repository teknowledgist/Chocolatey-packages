$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.16.7-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.16.7-trial-win64-installer.msi'
$checkSum32 = '51f4e73f7a7dfa9326990f80a297298fc8e906d914b2fc3c578fc568db223b2d'
$checkSum64 = 'e41ceafc1fc4c188bf364580b46efcfb05fc8694610fbdb9df6e470c117e6d8b'

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

