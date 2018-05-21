$ErrorActionPreference = 'Stop'  # stop on all errors

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   Url           = 'https://service-hpglview.web.cern.ch/service-hpglview/download/hpglview-543_Windows.zip' 
   checksum      = 'cd9d35477c4b44e484b17ebc718780fa81230f8183599593a83efe2d2197c94b'
   checksumType  = 'sha256'
   UnzipLocation = Join-Path $env:ChocolateyPackageFolder "V$env:ChocolateyPackageVersion"
}
Install-ChocolateyZipPackage @InstallArgs

$EscPath = $InstallArgs["UnzipLocation"] -replace '\\','\\'

New-Item -Path 'HKLM:\SOFTWARE\Classes\.hp2' -Value 'HpglView' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\.hpg' -Value 'HpglView' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\.hpgl' -Value 'HpglView' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\.plt' -Value 'HpglView' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\HpglView' -Value 'HP-GL Image' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\HpglView\shell' -Value 'open' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\HpglView\shell\open\command' -Value ('"\"' + $EscPath + '\\hpglview.exe\" \"%1\""') -force | Out-Null

