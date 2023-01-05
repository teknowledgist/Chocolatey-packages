$ErrorActionPreference = 'Stop'

# On upgrades, the NASM installer sometimes adds an additional Start 
#   Menu folder without removing the old one.  Take an inventory 
#   before install attempt.
$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu'
$PreSMfolders = Get-ChildItem $StartMenu -Filter "Netwide Assembler*" -Recurse -Directory | 
                     Select-Object -ExpandProperty fullname

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$Files = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 2

$File32 = ($Files | Where-Object {$_.Name -match 'x86\.exe'}).fullname
$File64 = ($Files | Where-Object {$_.Name -match 'x64\.exe'}).fullname

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   File           = $File32
   File64         = $File64
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

foreach ($File in $Files) {
   Remove-Item $File.fullname -ea 0 -force
}

# Take another inventory of NASM Start Menu folders after install
$PostSMfolders = Get-ChildItem $StartMenu -Filter "Netwide Assembler*" -Recurse -Directory |
                     Select-Object -ExpandProperty fullname

if ($PostSMfolders.count -eq 1) {
   $Folder2Rename = $PostSMfolders
} elseif (($PostSMfolders.count - $PreSMfolders.count) -eq 1) {
   # Remove old NASM Start Menu folders
   $PostSMfolders | ForEach-Object {
      if ($PreSMfolders -contains $_) {
         Remove-Item $_ -Recurse -Force
      } else {
         $Folder2Rename = $_
      }
   }
}

if ($Folder2Rename) {
   # Rename the remaining folder to strip the version number.
   $null = Rename-Item $Folder2Rename ($Folder2Rename -replace '[0-9.]','').trim() -Force
} else {
   Write-Warning "Can't rename NASM Start Menu folder!"
}

