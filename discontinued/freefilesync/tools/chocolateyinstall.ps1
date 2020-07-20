$ErrorActionPreference = 'Stop'
 
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
 
# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath AutoHotkey -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"
 
$packageArgs = @{
   packageName  = $env:ChocolateyPackageName
   url          = 'https://www.freefilesync.org/download/FreeFileSync_10.25_Windows_Setup.exe'
   Checksum     = 'de38ced68068569a5ffcc493ebba4f1791649aac1b119f57addc6a0c81711042'
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
