$ErrorActionPreference = 'Stop'
  
$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Anaconda3'
   fileType      = 'EXE'
   url           = 'https://repo.continuum.io/archive/Anaconda3-2019.10-Windows-x86.exe'
   url64bit      = 'https://repo.continuum.io/archive/Anaconda3-2019.10-Windows-x86_64.exe'
   checksum      = '05e6738919673a6d57b5895b8b4df0b7e3f4d7ed0e30faf9c9f1b7d3399e9f52'
   checksum64    = '9e632439ed40620b8518f11469ded7316eccb489d0dfc41770f72ca2b2202dd9'
   checksumType  = 'sha256'
   validExitCodes= @(0)
}

$ToolsDir   = Get-ToolsLocation

$pp = Get-PackageParameters

if (!$pp['JustMe']) { $T = 'AllUsers' } 
else { 
   Write-Host 'You have opted to install for the current user only.' -ForegroundColor Cyan
   $T = 'JustMe'
}

if (!$pp['DoNotRegister']) { $R = '1' } 
else { 
   Write-Host 'You have opted to NOT register this installation of Python.' -ForegroundColor Cyan
   $R = '0'
}

if (!$pp['AddToPath']) { $P = '0' } 
else { 
   Write-Host 'You have opted to add Anaconda Python to the path.' -ForegroundColor Cyan
   $P = '1'
}

if (!$pp['D']) {
    $D = Join-Path $ToolsDir 'Anaconda3'
} else {
    if (!(Test-Path $pp['D'])) {
        Write-Error "`nThe destination ('/D') parameter, '$($pp['D'])' is not an available path!"
    } else {
       Write-Host "You wish to install to the path: $($pp['D'])" -ForegroundColor Cyan
       $D = Join-Path $pp['D'] 'Anaconda3'
    }
}
  
$InstallArgs.add('silentArgs',"/S /InstallationType=$T /RegisterPython=$R /AddToPath=$P /D=$D")

Write-Warning 'The Anaconda3 installation can take a long time (up to 30 minutes).'
Write-Warning 'Please be patient and let it finish.'
Write-Warning 'If you want to verify the install is running, you can watch the installer process in Task Manager'

Install-ChocolateyPackage @InstallArgs
