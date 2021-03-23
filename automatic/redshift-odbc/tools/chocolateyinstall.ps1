$ErrorActionPreference = 'Stop'

$params = @{
   PackageName   = 'redshift-odbc'
   FileType      = 'msi'
   Url           = 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/1.4.20.1001/AmazonRedshiftODBC32-1.4.20.1001.msi'
   Url64bit      = 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/1.4.20.1001/AmazonRedshiftODBC64-1.4.20.1001.msi'
   Checksum      = '184723a2b70d5e3afb2b581b6f9c6766335b962926efeed462cffd3f2548fa38'
   Checksum64    = '95433df62b3870dc18d78cdc6e682a56f0eef173650190f7e264ca4bbb4c98fb'
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
