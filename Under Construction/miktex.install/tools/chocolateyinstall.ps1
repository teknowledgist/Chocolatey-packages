$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Grab the setup utility
$ZipArgs = @{
   PackageName   = $env:ChocolateyPackageName
   Url           = 'https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x86/miktexsetup-2.9.7442.zip'
   Url64         = 'https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/miktexsetup-2.9.7442-x64.zip'
   checkSum      = '55c1e1b6ecff7afc734452ff9931b3a9dcc46b1aad8b32281dd85001749b8adf'
   checkSum64    = '6e5996544cbd517b4c661f7642a9f6aae68cf85c92e56a7e1bb81ed33df1d153'
   checkSumType  = 'sha256'
   UnzipLocation = $toolsDir
}
Install-ChocolateyZipPackage @ZipArgs

$MiKTeXsetup = Get-ChildItem $toolsDir 'miktexsetup.exe' | Select-Object -ExpandProperty FullName
$null = New-Item "$MiKTeXsetup.ignore" -Type file -Force

$pp = Get-PackageParameters

# What kind of install?
Switch ($pp['set']) {
   'essential' { $set = 'essential'
                  $msg = 'Downloading a "Essential" package set to install.'; break }
   'Complete'  { $set = 'complete'
                  $msg = 'Downloading a "Complete" package set to install.\n' + 
                         'This is large and may take some time.  Please be patient.'; break }
   default     { $set = 'basic'
                  $msg = 'Downloading a "Basic" package set to install.'; break }
}
Write-Host $msg -ForegroundColor DarkCyan

# Is MiKTeX already installed?
[array]$key = Get-UninstallRegistryKey -SoftwareName "miktex*"
if ($key.Count -gt 1) {
   Throw "More than one install of MiKTeX already exists!"
} elseif ($key.Count -eq 1) {
   # Use MiKTeX's built-in updater
   $InstallDir = split-path ($key.UninstallString.split('"')[1])
   $InitEXMF = Join-Path $InstallDir "initexmf.exe"
   $MileStoneLine = & $InitEXMF --admin --report | Where-Object {$_ -match '^miktex'}
   $MileStone = $MileStoneLine.split[-1]
   Write-Host "Found MiKTeX milestone $MileStone currently installed." -ForegroundColor DarkCyan
   Write-Host "Updating to the latest MiKTeX milestone." -ForegroundColor DarkCyan

   $MPM = Join-Path $InstallDir "mpm.exe"
   $SetupArgs = @{
      Statements     = "/c `"$MPM`" --admin --verbose --update " +
                        "> `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).update.log`" 2>&1"
      ExetoRun       = $env:ComSpec
      validExitCodes = @(0)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @SetupArgs

} elseif ($key.Count -eq 0) {
   # MiKTeX install requires first creating a local repository:
   $Repository = Join-Path $env:TEMP 'MiKTeX-repository'
   $DownloadArgs = @{
      Statements     = "/c `"$MiKTeXsetup`" --verbose --local-package-repository=`"$Repository`" " +
                        "--package-set=$set download " +
                        "> `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).download.log`" 2>&1"
      ExetoRun       = $env:ComSpec
      validExitCodes = @(0)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @DownloadArgs

   # Then the actual install:
   $InstallArgs = @{
      Statements     = "/c `"$MiKTeXsetup`" --verbose --local-package-repository=`"$Repository`" " +
                        "--package-set=$set --shared install " #+
#                        "> `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).install.log`" 2>&1"
      ExetoRun       = $env:ComSpec
      validExitCodes = @(0)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @InstallArgs
}

# Once installed/updated, configure MiKTeX to automatically install missing packages on the fly
[array]$key = Get-UninstallRegistryKey -SoftwareName "$env:ChocolateyPackageName*"
$InstallDir = split-path ($key.UninstallString.split('"')[1])
$InitEXMF = Join-Path $InstallDir "initexmf.exe"
$SetupArgs = @{
   Statements     = "/c `"$InitEXMF`" --admin --verbose --set-config-value=[MPM]AutoInstall=1 " +
                     "> `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).config.log`" 2>&1"
   ExetoRun       = $env:ComSpec
   validExitCodes = @(0)
}
$exitCode = Start-ChocolateyProcessAsAdmin @SetupArgs

