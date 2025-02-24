$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'https://www.qcad.org/archives/qcad/qcad-3.32.2-trial-win32-installer.msi'
$url64 = 'https://www.qcad.org/archives/qcad/qcad-3.32.2-trial-win64-installer.msi'
$checkSum32 = 'c2176b9d88b3843d8cbb03d1f0ee8319e19a9e3d8c85d78446b1fce4332d8835'
$checkSum64 = 'f8cd40cf7a465f7873cb8dd67f7cf74f921bf712721d235abe3927653adcd605'

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

