$ErrorActionPreference = 'Stop'

$params = @{
   PackageName   = 'redshift-odbc'
   FileType      = 'msi'
   Url           = 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/1.4.34.1000/AmazonRedshiftODBC32-1.4.34.1000.msi'
   Url64bit      = 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/1.4.45.1000/AmazonRedshiftODBC64-1.4.45.1000.msi'
   Checksum      = '3aad0e51202f03929b98c95901a43f669f28484376c275954d82974a119d76ea'
   Checksum64    = '915B8192845508582931ADB0966E76EACD8F5955CBEED3ACF6DA7DBCC254BAC8'
   ChecksumType  = "sha256"
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
} 
Install-ChocolateyPackage @params

# 32-bit SQL client applications must have the 32-bit driver installed.
if ((Get-OSArchitectureWidth -Compare 64) -and (-not $Env:chocolateyForceX86)) { 
   $BackupForceX86 = $Env:chocolateyForceX86
   $Env:chocolateyForceX86 = $true
   Install-ChocolateyPackage @params
   $Env:chocolateyForceX86 = $BackupForceX86
}
