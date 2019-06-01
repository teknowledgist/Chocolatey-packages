$ErrorActionPreference = 'Stop'

$packageName = 'qcad'
$url32 = 'http://www.qcad.org//archives/qcad/qcad-3.22.0-trial-win32-installer.msi'
$url64 = 'http://www.qcad.org//archives/qcad/qcad-3.22.0-trial-win64-installer.msi'
$checkSum32 = 'c4dcc0d67484391901ebc7fa54416d6d42087019b32a3d4cad5ab9c0fe79a32c'
$checkSum64 = 'fbb89c29825e14cac1fa21fd267c00c0c697f6d698ef7bcf339c7ae210a73bc4'

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
   Options = @{
               Headers = @{
                  'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0'
                  referer = 'https://www.qcad.org/en/qcad-downloads-trial'
                  Cookie = 'c08dfa11cab8b59437d064060d5b637a=g954hai1eprq5iq2bdoe68gc15'
               }
   }

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

