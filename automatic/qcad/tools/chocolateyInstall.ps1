$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'https://www.qcad.org/archives/qcad/qcad-3.29.6-trial-win32-installer.msi'
$url64 = 'https://www.qcad.org/archives/qcad/qcad-3.29.6-trial-win64-installer.msi'
$checkSum32 = '3b4f5922da16e742a09933afec2d083c131a7a6e1d5de2f2df4683bf2894b1f1'
$checkSum64 = '3b5aa5052661956eaad5562e65a6289467889302b9f06c4948c458ca0f2dae72'

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

