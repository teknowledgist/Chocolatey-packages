$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

if (-not (Get-ChildItem -Path $toolsDir -Filter '*.exe')) {
   Throw ("$env:ChocolateyPackageName installer executable not found!`n" +
            "`tThis is an embedded package, so the most probable cause is that`n" +
            "`tanti-virus/anti-malware software has incorrectly removed it.`n" +
            "`tGo here for more info: https://www.freefilesync.org/faq.php#virus")
}
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

if (-not (Test-Path $fileLocation)) {
   Throw ("$env:ChocolateyPackageName installer executable not found!`n" +
            "`tThis is an embedded package, so the most probable cause is that`n" +
            "`tanti-virus/anti-malware software has incorrectly removed it.`n" +
            "`tGo here for more info: https://www.freefilesync.org/faq.php#virus")
}

Install-ChocolateyInstallPackage @packageArgs

New-Item "$fileLocation.ignore" -Type file -Force | Out-Null

if (get-process -id $ahkProc.Id -ErrorAction SilentlyContinue) {stop-process -id $ahkProc.Id}

Write-Host ("If you like FreeFileSync, consider support with a donation at`n" + 
            "`thttps://freefilesync.org/donate.php") -ForegroundColor Cyan
