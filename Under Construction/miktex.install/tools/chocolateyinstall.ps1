$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$ZipFiles = Get-ChildItem $toolsDir '*.zip' |Select-Object -ExpandProperty FullName

$ZipArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFiles | Where-Object {$_ -notmatch 'x64'}
   FileFullPath64 = $ZipFiles | Where-Object {$_ -match 'x64'}
   Destination    = $toolsDir
}
$null = Get-ChocolateyUnzip @ZipArgs

$MiKTeXsetup = Get-ChildItem $toolsDir 'miktexsetup.exe' | Select-Object -ExpandProperty FullName
$null = New-Item -Path "$MiKTeXsetup.ignore" -ItemType file -Force

$pp = Get-PackageParameters

# What kind of install?
Switch ($pp['set']) {
   'essential' { $set = 'essential'
                  $msg = 'Downloading a "Essential" package set to install.'; break }
   'complete'  { $set = 'complete'
                  $msg = 'Downloading a "Complete" package set to install.\n' + 
                         'This is large and may take some time.  Please be patient.'; break }
   default     { $set = 'basic'
                  $msg = 'Downloading a "Basic" package set to install.'; break }
}
Write-Host $msg -ForegroundColor Cyan

$LocalRepo = $false
$Repository = ''
if ($pp['RepoPath']) {
   $LocalRepo = [uri]($pp['RepoPath']).AbsoluteUri.StartsWith('file:')
   $Repository = $pp['RepoPath']
}

# Is MiKTeX already installed?
[array]$key = Get-UninstallRegistryKey -SoftwareName 'miktex*' 
if ($key.Count -gt 1) {
   Throw 'More than one install of MiKTeX already exists!'
} elseif ($key.Count -eq 1) {
   # Use MiKTeX's built-in updater
   $InstallDir = split-path ($key.UninstallString.split('"')[1])
   $InitEXMF = Join-Path $InstallDir 'initexmf.exe'
   $MileStoneLine = & $InitEXMF --admin --report | Where-Object {$_ -match '^miktex'}
   $MileStone = $MileStoneLine.split[-1]
   Write-Host "Found MiKTeX milestone $MileStone currently installed." -ForegroundColor Cyan
   Write-Host 'Updating to the latest MiKTeX milestone.' -ForegroundColor Cyan

   if ($LocalRepo) {
      if (test-path $Repository) {
         Write-Verbose "Updating local MiKTeX repository at '$Repository'."
      } else {
         Write-Verbose "Local MiKTeX repository not found.  Creating one at '$Repository'."
      }
      $DownloadArgs = @{
         Statements       = "--verbose --local-package-repository=`"$Repository`" --package-set=$set download "
         ExetoRun         = $MiKTeXsetup
         WorkingDirectory = $toolsDir
         validExitCodes   = @(0)
      }
      $exitCode = Start-ChocolateyProcessAsAdmin @DownloadArgs
      if ($exitCode -ne 0) {
         Throw 'Local Repository failure!'
      }
   }

   $MPM = Join-Path $InstallDir 'mpm.exe'
   if ($Repository -ne '') { $RepoSwitch = "--repository=`"$Repository`"" }
   $SetupArgs = @{
      Statements       = "--admin --verbose --update $RepoSwitch"
      ExetoRun         = $MPM
      WorkingDirectory = $InstallDir
      validExitCodes   = @(0)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @SetupArgs

} elseif ($key.Count -eq 0) {
   # MiKTeX install requires a repository
   if ($Repository -eq '') {
      # Use a temporary repository if one not given
      $Repository = Join-Path $env:TEMP 'MiKTeX-repository'
      $LocalRepo = $true
      Write-Verbose "Will use a temporary MiKTeX repository at '$Repository'."
   }

   if ($LocalRepo) {
      $RepoSwitch = "--local-package-repository=`"$Repository`""

      # Only create a repository if it is local; remote repositories need to be updated independently.
      Write-Verbose "Creating MiKTeX repository at '$Repository'."
      $DownloadArgs = @{
         Statements       = "--verbose $RepoSwitch --package-set=$set download "
         ExetoRun         = $MiKTeXsetup
         WorkingDirectory = $toolsDir
         validExitCodes   = @(0)
      }
      $exitCode = Start-ChocolateyProcessAsAdmin @DownloadArgs
      if ($exitCode -ne 0) {
         Throw 'Local Repository failure!'
      }
   } else {
      $RepoSwitch = "--Remote-package-repository=`"$Repository`""
   }

   # Now, do the actual install from identified repository
   Write-Verbose 'Installing from temporary MiKTeX repository.'
   $InstallArgs = @{
      Statements       = "--verbose $RepoSwitch --package-set=$set --shared install "
      ExetoRun         = $MiKTeXsetup
      WorkingDirectory = $toolsDir
      validExitCodes   = @(0)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @InstallArgs
   if ($exitCode -ne 0) {
      Throw "MiKTeX setup utility failed to install MiKTeX with error, $exitCode"
   }
}

# Once installed/updated, confirm it's the correct milestone.
[array]$key = Get-UninstallRegistryKey -SoftwareName 'miktex*'
$InstallDir = split-path ($key.UninstallString.split('"')[1])
$InitEXMF = Join-Path $InstallDir 'initexmf.exe'
$MileStoneLine = & $InitEXMF --admin --report | Where-Object {$_ -match '^miktex'}
$MileStone = $MileStoneLine.split[-1]
If ([version]$MileStone -lt $env:ChocolateyPackageVersion) {
   Throw "Repository was only able to update MiKTeX to v.$MileStone."
}

# configure MiKTeX to automatically install missing packages on the fly
Write-Verbose 'Adjusting settings so MiKTeX installs missing packages on the fly.'
$SetupArgs = @{
   Statements       = '--admin --verbose --set-config-value=[MPM]AutoInstall=1'
   ExetoRun         = $InitEXMF
   WorkingDirectory = $InstallDir
   validExitCodes   = @(0)
}
$exitCode = Start-ChocolateyProcessAsAdmin @SetupArgs


