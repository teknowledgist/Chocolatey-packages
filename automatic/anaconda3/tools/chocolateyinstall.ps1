$ErrorActionPreference = 'Stop'
  
$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Anaconda3'
   fileType      = 'EXE'
   url           = 'https://repo.anaconda.com/archive/Anaconda3-2022.05-Windows-x86.exe'
   url64bit      = 'https://repo.anaconda.com/archive/Anaconda3-2022.05-Windows-x86_64.exe'
   checksum      = 'cd8c688349bcd1f429e3b383620fb0d19f52be0f765b2eae78d63b41aefb2e73'
   checksum64    = '2766eb102f9d65da36d262b651777358de39fbe5f1a74f9854a2e5e29caeeeec'
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
