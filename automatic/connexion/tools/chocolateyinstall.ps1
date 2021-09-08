$ErrorActionPreference = 'Stop'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.exe"
   Url          = 'https://help.oclc.org/@api/deki/files/12679/ConnexClient3.0.7905.exe?revision=1'
   Checksum     = '9f677b0628ef35717399e5093a978868e9b1e11090034c768b014a232e3b8078'
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

