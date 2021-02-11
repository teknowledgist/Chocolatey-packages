$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -filter '*.exe' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE' 
   file           = "$fileLocation"
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $fileLocation -ea 0 -force

# The installer places the Start Menu shortcut in the current user profile only
$UserStart = Join-Path $env:APPDATA '\Microsoft\Windows\Start Menu\Programs'
$OrigLNK = Get-ChildItem -Path $UserStart -Filter "$env:ChocolateyPackageName.lnk" -Recurse

# Creating a Start Menu shortcut for all users.
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
If (($OrigLNK -ne $null) -and (Test-Path $OrigLNK)) {
   $NewLNK = Copy-Item $OrigLNK.FullName $StartPrograms -Force -PassThru
   $null = Remove-Item $OrigLNK.FullName
} else {
   # Installing as SYSTEM doesn't create a Start Menu shortcut at all
   [array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

   if ($key.Count -eq 1) {
      $InstallDir = Split-Path $key[0].UninstallString
      $targetPath = Join-Path $InstallDir "MARCView.exe"
      $StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
      $shortcutFilePath = Join-Path $StartPrograms 'MARCView.lnk'

      Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
   } else {
     Write-Warning "Start Menu shortcut could not be created."
   }
}

