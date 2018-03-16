$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe').FullName

# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath AutoHotkey -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileType     = 'EXE' 
  file         = $fileLocation
  softwareName = "$env:ChocolateyPackageName*"
  silentArgs   = '\LANG=english_uk'
}

Install-ChocolateyInstallPackage @packageArgs

New-Item "$fileLocation.ignore" -Type file -Force | Out-Null

if (get-process -id $ahkProc.Id -ErrorAction SilentlyContinue) {stop-process -id $ahkProc.Id}

Write-Host ("If you like FreeFileSync, consider support with a donation at`n" + 
            "`thttps://freefilesync.org/donate.php") -ForegroundColor Cyan
