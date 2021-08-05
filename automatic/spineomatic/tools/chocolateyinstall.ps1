$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$App = Get-ChildItem -Path $toolsDir -Filter '*.exe' | 
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

$pp = Get-PackageParameters

# Where to put?
if ($pp['path']) {
   $Destination = $pp['path']
} else {
   $Destination = 'C:\Spine'
}
Write-Host "The SpineOMatic executable will be placed in '$Destination'." -ForegroundColor DarkCyan

if (-not (Test-path $Destination)) {
   Write-Warning "'$Destination' does not exist.  Creating '$Destination'."
   $null = New-Item -Path $Destination -ItemType Directory -Force
}

if ($pp['settings']) {
   if (Test-path $pp['settings']) {
      Write-Verbose "New settings file found: $($pp['settings'])"
      if (Test-Path "$Destination\settings.som") {
         $BackupFile = Join-Path $Destination "Previous_settings_$env:ChocolateyPackageVersion.txt"
         Write-Verbose "Previous settings file found.  It will be saved as: $BackupFile"
         Rename-Item -Path "$Destination\settings.som" -NewName $BackupFile -Force
      }
      Copy-Item -Path $pp['settings'] -Destination "$Destination\settings.som"
   } else {
      Write-Warning "New settings file NOT found!: $($pp['settings'])"
   }
}


$Null = Copy-Item -Path $App -Destination $Destination -Force
$null = Remove-Item -Path $App -Force

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms 'SpineOMatic.lnk'
$targetPath = Join-Path $Destination 'SpineLabeler.exe'

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath

