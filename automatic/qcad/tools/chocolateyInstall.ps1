$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
#$url32 = 'https://www.qcad.org/archives/qcad/qcad-27.0.0-trial-win32-installer.msi'
$url64 = 'https://www.qcad.org/archives/qcad/qcad-27.0.0-trial-win64-qt6-installer.msi'
#$checkSum32 = ''
$checkSum64 = '502d9988df1787030d1d426a8f1b7c280d4463008475559e8ea4daa7dd3e4530'

$InstallArgs = @{
   packageName = $env:ChocolateyPackageName
   installerType = 'msi'
#   url = $url32
   url64bit = $url64
#   Checksum = $checkSum32
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

