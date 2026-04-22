$ErrorActionPreference = 'Stop'  # stop on all errors

$DownloadArgs = @{
   PackageName  = $env:chocolateyPackageName
   Url          = 'https://www.digimizer.com/download/digimizersetup.exe'
   Checksum     = '797011a5ab3369c9a8da988304eefcb3e4434842f890e60ec37bf20d8f13b1ef'
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

