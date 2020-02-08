$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerPath = (Get-ChildItem -Path $toolsDir -filter '*.exe' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName

if (-not $InstallerPath) {
   $ZipPath = (Get-ChildItem -Path $toolsDir -filter '*.zip').FullName
   Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination $toolsDir
   $InstallerPath = (Get-ChildItem -Path $toolsDir -filter '*.exe').FullName
}

$ProgDir = Join-Path $env:ProgramFiles 'FastCopy'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = "$InstallerPath"
   silentArgs     = "/silent /dir=`"$ProgDir`""
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
Remove-Item $InstallerPath -ea 0 -force

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

New-Item "$InstallerPath.ignore" -Type file -Force | Out-Null
