$ErrorActionPreference = 'Stop'

$PackageMileStone = '21.12'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Remove any previously unzipped installers
Get-ChildItem $toolsDir -Filter *.exe -Recurse | ForEach-Object { Remove-Item $_.fullname -Force }

$ZipFiles = Get-ChildItem -Path $toolsDir -Filter '*.zip' | Sort-Object LastWriteTime | Select-Object -ExpandProperty FullName -Last 2 

$ZipArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFiles | Where-Object {$_ -notmatch 'x64'}
   FileFullPath64 = $ZipFiles | Where-Object {$_ -match 'x64'}
   Destination    = $toolsDir
}
$null = Get-ChocolateyUnzip @ZipArgs

$MiKTeXsetup = Get-ChildItem $toolsDir 'miktexsetup*.exe' -Recurse | Select-Object -ExpandProperty FullName
Write-Verbose "Found setup utility:  $MiKTeXsetup"
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
$Mirror = ''
if ($pp['RepoPath']) {
   $LocalRepo = -not (([uri]($pp['RepoPath'])).hostnametype.tostring().equals('Dns'))
   $Repository = $pp['RepoPath']
   if (-not $LocalRepo) {
      if ($Repository -match '^(https?:|ftp:)') {
         Throw "RepoPath must be a local or UNC path!"
      }
   }
} 
# Include a list of mirrors in logs if Mirror is called
if ($pp['Mirror']) {
   $List = & $MiKTeXsetup --list-repositories
   $List = $List -join "`n`t"
   Write-Verbose "`nRegistered repositories:`n`t$list"
   
   $Mirror = $pp['Mirror']
   Write-Verbose "Attempting to download from specified mirror:  $Mirror"
   $MirrorSwitch = "--remote-package-repository=`"$Mirror`""
} else { $MirrorSwitch = '' }

# Is MiKTeX already installed?
[array]$key = Get-UninstallRegistryKey -SoftwareName 'miktex*' 
if ($key.Count -gt 1) {
   Throw 'More than one install of MiKTeX already exists!'
} elseif ($key.Count -eq 1) {
   if ($key.PSPath -match 'HKEY_CURRENT_USER') { $admin = '' } else { $admin = '--admin' }
   # Use MiKTeX's built-in updater
   $InstallDir = (Split-Path $key.UninstallString).trim('"')
   Write-Verbose "Found an install of MiKTeX at '$InstallDir'."
   $InitEXMF = Join-Path $InstallDir 'initexmf.exe'
   Write-Verbose "Running 'initexmf.exe' to identify installed milestone."
   $MileStoneLine = & $InitEXMF $admin --report | Where-Object {$_ -match '^(CurrentVersion|MiKTeX):'}
   $MileStone = $MileStoneLine.split()[-1]
   Write-Host "Found MiKTeX milestone $MileStone currently installed." -ForegroundColor Cyan

   If (([Version]$MileStone -lt [Version]$PackageMileStone) -or $env:ChocolateyForce) {
      Write-Host 'Updating to the latest MiKTeX milestone.' -ForegroundColor Cyan

      if ($LocalRepo) {
         if (test-path $Repository) {
            Write-Verbose "Updating local MiKTeX repository at '$Repository'."
         } else {
            Write-Verbose "Local MiKTeX repository not found.  Creating one at '$Repository'."
         }

         $DownloadArgs = @{
            Statements       = "--verbose --local-package-repository=`"$Repository`" $MirrorSwitch --package-set=$set download "
            ExetoRun         = $MiKTeXsetup
            WorkingDirectory = $toolsDir
            validExitCodes   = @(0)
         }
         $exitCode = Start-ChocolateyProcessAsAdmin @DownloadArgs
      }

      $MPM = Join-Path $InstallDir 'mpm.exe'
      if ($Repository -eq '' -and $Mirror -ne '') { $Repository = $Mirror }
      if ($Repository -ne '') { $RepoSwitch = "--repository=`"$Repository`"" }
      $SetupArgs = @{
         Statements       = "$admin --verbose --update $RepoSwitch"
         ExetoRun         = $MPM
         WorkingDirectory = $InstallDir
         validExitCodes   = @(0)
      }
      $exitCode = Start-ChocolateyProcessAsAdmin @SetupArgs
   } else {
      Write-Verbose 'Installed Milestone of MiKTeX is the same or newer than this package version.'
      Return
   }

} elseif ($key.Count -eq 0) {
   # MiKTeX install requires a repository
   if ($Repository -eq '') {
      # Use a temporary repository if one not given
      $Repository = Join-Path $env:TEMP 'MiKTeX-repository'
      $LocalRepo = $true
      $Temporary = ' temporary'
   }

   $RepoSwitch = "--local-package-repository=`"$Repository`""

   if ($LocalRepo) {
      # Only create a repository if it is local; remote repositories need to be updated independently.
      Write-Host "Creating a$Temporary repository at '$Repository'."
      $DownloadArgs = @{
         Statements       = "--verbose $RepoSwitch $MirrorSwitch --package-set=$set download "
         ExetoRun         = $MiKTeXsetup
         WorkingDirectory = $toolsDir
         validExitCodes   = @(0)
      }
      $exitCode = Start-ChocolateyProcessAsAdmin @DownloadArgs
   }


   # Now, do the actual install from identified repository
   $installmsg = "Installing from$Temporary MiKTeX repository for "
   if ($pp['ThisUser']) { 
      $admin = ''
      $Shared = 'no' 
      $installmsg += 'just this user.'
   } else { 
      $admin = '--admin'
      $shared = 'yes'
      $installmsg += 'all users.'
   }
   Write-Host $installmsg
   $InstallArgs = @{
      Statements       = "--verbose $RepoSwitch --package-set=$set --shared=$Shared install "
      ExetoRun         = $MiKTeXsetup
      WorkingDirectory = $toolsDir
      validExitCodes   = @(0)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @InstallArgs
}

# Once installed/updated, confirm it's the correct milestone.
[array]$key = Get-UninstallRegistryKey -SoftwareName 'miktex*'
$InstallDir = (Split-Path $key.UninstallString).trim('"')
$InitEXMF = Join-Path $InstallDir 'initexmf.exe'
Write-Verbose "Using 'initexmf.exe' to identify installed milestone."

$ErrorActionPreference = 'SilentlyContinue'
$MileStoneLine = & "$InitEXMF" $admin --report 2>&1 | Where-Object {$_ -match '^CurrentVersion:'}
$ErrorActionPreference = 'Stop'

$MileStone = $MileStoneLine.split()[-1]
Write-Verbose "Verified MiKTeX milestone $MileStone installed."
If ([version]$MileStone -lt [version]$PackageMileStone) {
   Throw "Repository was unable to provide MiKTeX milestone $PackageMileStone"
}

# configure MiKTeX to automatically install missing packages on the fly
Write-Verbose 'Adjusting settings so MiKTeX installs missing packages on the fly.'
$SetupArgs = @{
   Statements       = "$admin --verbose --set-config-value=[MPM]AutoInstall=1"
   ExetoRun         = $InitEXMF
   WorkingDirectory = $InstallDir
   validExitCodes   = @(0)
}
$exitCode = Start-ChocolateyProcessAsAdmin @SetupArgs


