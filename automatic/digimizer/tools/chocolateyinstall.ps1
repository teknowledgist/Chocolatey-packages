$ErrorActionPreference = 'Stop'  # stop on all errors

$DownloadArgs = @{
   PackageName  = $env:chocolateyPackageName
   Url          = 'https://www.digimizer.com/download/digimizersetup.exe'
   Checksum     = '799b377500675908245445632bb8dbbe5dd5ef4130f448cc222d7967180c15f7'
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

