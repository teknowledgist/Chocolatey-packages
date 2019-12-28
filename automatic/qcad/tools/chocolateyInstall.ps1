$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'http://www.qcad.org/archives/qcad/qcad-3.24.0-trial-win32-installer.msi'
$url64 = 'https://www.qcad.org/archives/qcad/qcad-3.24.0-trial-win64-installer.msi'
$checkSum32 = '619e2b138c6c5a667479b332dfec778aa7453b113b9eb5122ab0029f0dad3573'
$checkSum64 = 'ac46cf9a02899a3c9ef618d437a3d8bb9f9017f1d516e001f99d01cd67d3bcf4'

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

$UserArguments = Get-PackageParameters

if ($UserArguments['CommunityEdition']) {
   # QCAD is GPLv3, but the binary download comes burdened with with a couple commercial trial plugins.
   # Removing a few files eliminates the proprietary pieces.
   $TrialFiles = 'qcaddwg.dll','qcadopengl3d','qcadpolygon.dll','qcadproscripts.dll','qcadtriangulation.dll'

   foreach ($file in $TrialFiles) {
      if (test-path (Join-Path $env:ProgramFiles "QCAD\plugins\$file")) {
         Remove-Item (Join-Path $env:ProgramFiles "QCAD\plugins\$file") -Force
      }
   }
}

