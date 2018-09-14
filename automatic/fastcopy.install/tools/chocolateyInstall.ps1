$ErrorActionPreference = 'Stop'
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipPath = (Get-ChildItem -Path $toolsDir -filter '*.zip').FullName

# Extract zip
$UnZipPath = Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination (Join-Path $env:TEMP $env:ChocolateyPackageName)

$ProgDir = Join-Path $env:ProgramFiles 'FastCopy'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = (Get-ChildItem -Path $UnZipPath -filter '*.exe').FullName
   silentArgs     = "/silent /dir=`"$ProgDir`""
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath AutoHotkey -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "AutoHotKey Process ID:`t$($ahkProc.Id)"

Start-ChocolateyProcessAsAdmin -ExeToRun (Join-Path $ProgDir 'FastCopy.exe')

$Shortcut = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\FastCopy.lnk"
if (Test-Path $Shortcut) {
   Copy-Item $Shortcut "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
}

