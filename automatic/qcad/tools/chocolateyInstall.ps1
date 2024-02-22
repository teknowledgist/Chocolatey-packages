$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'https://www.qcad.org/archives/qcad/qcad-3.29.4-trial-win32-installer.msi'
$url64 = 'https://www.qcad.org/archives/qcad/qcad-3.29.4-trial-win64-installer.msi'
$checkSum32 = 'c0821a0f50c8dd87595fd0b9784fb07bae8eff121d81f0a49bad7d40a7b8a360'
$checkSum64 = '3878095d3244f653d87e3045bdde6ff7ad99999dde5573fa8233f62d67b17ce3'

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

