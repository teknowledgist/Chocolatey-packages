$InstallArgs = @{
   packageName = 'qcad'
   installerType = 'exe'
   url = 'http://www.qcad.org/archives/qcad/qcad-3.14.3-win32-installer.exe'
   url64bit = 'http://www.qcad.org/archives/qcad/qcad-3.14.3-win64-installer.exe'
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

