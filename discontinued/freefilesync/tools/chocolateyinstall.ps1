$ErrorActionPreference = 'Stop'
 
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
 
# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath AutoHotkey -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"
 
$packageArgs = @{
   packageName  = $env:ChocolateyPackageName
   url          = 'https://www.freefilesync.org/download/FreeFileSync_10.19_Windows_Setup.exe'
   Checksum     = '659fbc50b4f4bc210d7d06ab19b5b5f921254106070c30cef5da273874d5948f'
   ChecksumType = 'sha256'
   fileType     = 'EXE'
   softwareName = "$env:ChocolateyPackageName*"
   silentArgs   = ''
}

Install-ChocolateyPackage @packageArgs
 
New-Item "$fileLocation.ignore" -Type file -Force | Out-Null
 
if (get-process -id $ahkProc.Id -ErrorAction SilentlyContinue) {stop-process -id $ahkProc.Id}
 
Write-Host ("If you like FreeFileSync, consider support with a donation at`n" + 
            "`thttps://freefilesync.org/donate.php") -ForegroundColor Cyan
