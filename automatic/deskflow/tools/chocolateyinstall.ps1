$ErrorActionPreference = 'Stop'

# Stop installation if incompatibilies are found
$Incompatible = @()
Foreach ($Entry in (Get-UninstallRegistryKey -SoftwareName 'barrier*' -WarningAction SilentlyContinue)) {
   $Incompatible += $Entry.DisplayName
}
Foreach ($Entry in (Get-UninstallRegistryKey -SoftwareName 'input-leap*' -WarningAction SilentlyContinue)) {
   $Incompatible += $Entry.DisplayName
}
Foreach ($Entry in (Get-UninstallRegistryKey -SoftwareName 'synergy*' -WarningAction SilentlyContinue)) {
   $Incompatible += $Entry.DisplayName
}
If ($Incompatible) {
   Throw "$($Incompatible -join ' and ') must be uninstalled before Deskflow will install!"
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Installing ARM64 build.'
   $Filter = 'ARM64\.msi'
} else {
   $Filter = 'x64\.msi'
}

$Installers = Get-ChildItem $toolsDir -filter '*.msi' | Sort-Object LastWriteTime | Select-Object -Last 2

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   File64         = $Installers | Where-Object {$_.fullname -match $Filter} | Select-Object -ExpandProperty fullname
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs 

$Installers | ForEach-Object {remove-item $_.fullname -Force}
