$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$FolderOfPackage = Split-Path -Parent $toolsDir

$InstallerFile = (Get-ChildItem -Path $toolsDir -filter '*.exe' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName

# Remove old versions
$Previous = Get-ChildItem $FolderOfPackage -Filter v* | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

# Installer does not have machine-wide option, but can install to a different location.
# The Chocolatey package folder is used to make uninstall easier.
$Destination = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   file           = $InstallerFile
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs      = "/S /ALLUSERS=1 /D=$Destination"
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $InstallerFile -Force

$files = Get-ChildItem $FolderOfPackage -Filter *.exe -Recurse 
foreach ($EXE in $files) {
  #generate an ignore file
  $null = New-Item "$($EXE.fullname).ignore" -type file -force
}

# Uninstall doesn't work for non-default install location, so may as well
#    remove the uninstall registry key.
[array]$Keys = Get-UninstallRegistryKey -SoftwareName "LDtk *"
if (($Keys.Count -eq 1) -and ($Keys[0].PSPath -match "HKEY_CURRENT_USER")) {
   $UninstallKey = $Keys[0]
   try {
      Remove-Item -Path $UninstallKey.PSPath -Force
   } Catch {
      $multiLine = "Uninstall registry key for current user could not be removed. `n" +
                  "   Uninstall from the Windows interface won't work, but won't hurt anything either. `n" +
                  "   Chocolatey Uninstall will still work."
      Write-Warning $multiLine 
   }
} else {
   Write-Warning "LDtk install for all users may be working now or something strange occurred."
}

#    We want to create a Start Menu shortcut for all users.
$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcut = Join-Path $StartMenu 'LDtk.lnk'
$Target = Get-ChildItem $Destination -Filter "LDtk.exe" -recurse

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $Target.FullName -WorkingDirectory $Target.DirectoryName

