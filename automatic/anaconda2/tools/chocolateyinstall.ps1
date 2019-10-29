$ErrorActionPreference = 'Stop'
  
$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Anaconda2'
   fileType      = 'EXE'
   url           = 'https://repo.continuum.io/archive/Anaconda2-2019.10-Windows-x86.exe'
   url64bit      = 'https://repo.continuum.io/archive/Anaconda2-2019.10-Windows-x86_64.exe'
   checksum      = 'b4731acd02f96923922d995bb16984d71b4a934b7af6737984dd9eb5d8cc6389'
   checksum64    = '3e09c8e95e10f077be1e1d26f26df8d6a13356449e06d7d47ddc066fbaf435f5'
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
    $D = Join-Path $ToolsDir 'Anaconda2'
} else {
    if (!(Test-Path $pp['D'])) {
        Write-Error "`nThe destination ('/D') parameter, '$($pp['D'])' is not an available path!"
    } else {
       Write-Host "You wish to install to the path: $($pp['D'])" -ForegroundColor Cyan
       $D = Join-Path $pp['D'] 'Anaconda2'
    }
}
  
$InstallArgs.add('silentArgs',"/S /InstallationType=$T /RegisterPython=$R /AddToPath=$P /D=$D")

Write-Warning 'The Anaconda2 installation can take a long time (up to 30 minutes).'
Write-Warning 'Please be patient and let it finish.'
Write-Warning 'If you want to verify the install is running, you can watch the installer process in Task Manager'

Install-ChocolateyPackage @InstallArgs
