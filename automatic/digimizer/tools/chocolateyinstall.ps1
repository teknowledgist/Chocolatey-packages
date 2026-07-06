$ErrorActionPreference = 'Stop'  # stop on all errors

$DownloadArgs = @{
   PackageName  = $env:chocolateyPackageName
   Url          = 'https://www.digimizer.com/download/digimizersetup.exe'
   Checksum     = 'f45b4f3dfa3c2b2a6399b793b5ec4e1353c6703848fe2c9bbb9293599323eefd'
   ChecksumType = 'sha256'
   FileFullPath = Join-Path $env:TEMP "$env:chocolateyPackageName.$env:chocolateyPackageVersion/DigimizerSetup.exe"
   GetOriginalFileName = $true
}
$InstallerPath = Get-ChocolateyWebFile @DownloadArgs

if ((Get-ChildItem $InstallerPath).Extension -eq '.exe') {
   $ExeArgs = @{
      PackageName    = $env:chocolateyPackageName
      FileType       = 'EXE'
      File           = $InstallerPath
      silentArgs     = "/quiet"
      validExitCodes = @(0, 3010, 1641)
   }
   Install-ChocolateyInstallPackage @EXEArgs 
} else {
   $MSIArgs = @{
      PackageName   = $env:chocolateyPackageName
      FileType      = 'MSI'
      File          = $InstallerPath
      silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
      validExitCodes= @(0, 3010, 1641)
   }
   Install-ChocolateyInstallPackage @MSIArgs 
} 

