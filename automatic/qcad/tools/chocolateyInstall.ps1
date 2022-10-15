$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'https://www.qcad.org/archives/qcad/qcad-3.27.8-trial-win32-installer.msi'
$url64 = 'https://www.qcad.org/archives/qcad/qcad-3.27.8-trial-win64-installer.msi'
$checkSum32 = 'f3da69b695229747b8ef79975279120ad0cbea47a9460debf3431739bdcad060'
$checkSum64 = 'c9f42bb4d0d156792195095e4c6e004cf35d7580017885743042c5d8f9606de5'

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

