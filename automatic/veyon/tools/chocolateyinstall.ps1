$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$files = Get-ChildItem $toolsDir -Filter '*.exe'

$File32 = ($files | Where-Object {$_.Name -match "win32"}).fullname
$File64 = ($files | Where-Object {$_.Name -match "win64"}).fullname

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   fileType     = 'EXE' 
   File         = $File32
   File64       = $File64
   softwareName = "$env:ChocolateyPackageName*"
}

$pp = Get-PackageParameters

if (!$pp['Master']) { $M = ' /NoMaster' } 
else { 
   Write-Host 'You have opted to install the Master application.' -ForegroundColor Cyan
   $M = ''
}

if (!$pp['config']) {
    $C = ''
} else {
    if (!(Test-Path $pp['Config'])) {
        Write-Error "`nThe configuration parameter, '$($pp['Config'])' is not an accessible path!"
    } else {
       Write-Host "You wish to use the configuration file: $($pp['Config'])" -ForegroundColor Cyan
       $C = " /ApplyConfig=$($pp['Config'])"
    }
}

$InstallArgs.add('silentArgs',"/S$M$C")

Install-ChocolateyInstallPackage @InstallArgs

$exes = Get-ChildItem $toolsDir -filter *.exe -Recurse |Select-Object -ExpandProperty fullname
foreach ($exe in $exes) {
   New-Item "$exe.ignore" -Type file -Force | Out-Null
}
