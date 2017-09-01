$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.17.3-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.17.3-trial-win64-installer.msi'
$checkSum32 = 'fe4dd0b8f9e8398430387180a6d800b1601f8d2f69f8189f27fbd771f2012c2b'
$checkSum64 = '59bc92bfc56b50692e3b93df35d219a3499ea979cd7b6b879794e999616764d3'

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

