$ErrorActionPreference = 'Stop'  # stop on all errors

$DownloadArgs = @{
   PackageName  = $env:chocolateyPackageName
   Url          = 'https://www.digimizer.com/download/digimizersetup.exe'
   Checksum     = 'e0ba7724d365e1a30d38890d5703d4432c210853113901944d1aa74079a83d94'
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

