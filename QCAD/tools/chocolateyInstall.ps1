$version = '3.15.4'

$InstallArgs = @{
   packageName = 'qcad'
   installerType = 'exe'
   url = "http://www.qcad.org/archives/qcad/qcad-$version-win32-installer.exe"
   url64bit = "http://www.qcad.org/archives/qcad/qcad-$version-win64-installer.exe"
   Checksum = '148b46f25b405dea0a2a2f153a20e4caf9c99ad0'
   Checksum64 = '1c5357da90de0434c768346a26100c8702fbda5f'
   ChecksumType = 'sha1'
   silentArgs = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

# QCAD is GPLv3, but the binary download comes burdened with with a couple commercial trial plugins.
# Removing a few files eliminates the proprietary pieces.
$TrialFiles = 'qcadcamscripts.dll','qcaddwg.dll','qcadpolygon.dll','qcadproscripts.dll','qcadtriangulation.dll'

foreach ($file in $TrialFiles) {
   Remove-Item (Join-Path $env:ProgramFiles "QCAD\plugins\$file") -Force
}

