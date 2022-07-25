$ErrorActionPreference = 'Stop'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.exe"
   Url          = 'https://help.oclc.org/@api/deki/files/13899/ConnexClient3.1.8196.exe?revision=1'
   Checksum     = 'fc23ca79d205916b1b9e56a81e50c3b5189dfd5c5655d5a7dcf76d5801dd5f55'
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}
$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = $PackedInstaller
   Destination  = Join-Path $env:TEMP "$env:ChocolateyPackageName-UnZipped"
}
Get-ChocolateyUnzip @UnzipArgs

$MSIs = Get-ChildItem -Path $UnzipArgs.Destination -Filter '*.msi' 

foreach ($MSI in $MSIs) {
   $InstallArgs = @{
      PackageName    = $MSI.BaseName
      File           = $MSI.FullName
      fileType       = 'msi'
      silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($MSI.BaseName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
      validExitCodes = @(0, 3010, 1641)
   }
   Install-ChocolateyInstallPackage @InstallArgs
}

