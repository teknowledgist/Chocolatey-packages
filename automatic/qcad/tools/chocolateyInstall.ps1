$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'https://www.qcad.org/archives/qcad/qcad-3.28.1-trial-win32-installer.msi'
$url64 = 'https://www.qcad.org/archives/qcad/qcad-3.28.1-trial-win64-installer.msi'
$checkSum32 = '4d39dbda60e18cf9410b2c672f7ce7bd634e01455c10cb012f38b04a0ef02902'
$checkSum64 = 'c5990915b2781bcc3dd1b1dc6ed9a3297de773846b90d069ea8738035eca8ae6'

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

