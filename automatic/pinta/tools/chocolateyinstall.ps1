$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -filter '*.exe' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   file           = $fileLocation
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs      = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $DLArgs = @{
      packageName         = $env:ChocolateyPackageName
      URL64bit            = 'https://github.com/PintaProject/Pinta/releases/download/3.1.2/Pinta-arm64.exe'
      FileFullPath        = "$env:Temp\$($env:ChocolateyPackageName)_v$env:ChocolatepPackageVersion\Arm64Installer.exe"
      Checksum64          = '86e8804f6199aaa83674945b098133a5608a661224fa17df0edc89b984c6203e'
      GetOriginalFileName = $true
   }
   $PackageArgs.file = Get-ChocolateyWebFile @DLArgs
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $fileLocation -Force

