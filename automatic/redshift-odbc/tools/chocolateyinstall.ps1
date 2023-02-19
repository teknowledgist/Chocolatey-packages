$ErrorActionPreference = 'Stop'

$params = @{
   PackageName   = 'redshift-odbc'
   FileType      = 'msi'
   Url           = 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/1.4.52.1000/AmazonRedshiftODBC32-1.4.52.1000.msi'
   Url64bit      = 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/1.4.65.1000/AmazonRedshiftODBC64-1.4.65.1000.msi'
   Checksum      = 'fccd335dbfc0c3ee48d3af244dfc1f32eac29eca4d6dfac4ad8ad8eb8ae835d5'
   Checksum64    = '7e5327133df020bb6417fc09e523775e4d215babd276b2db19b1771100e2bd74'
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
