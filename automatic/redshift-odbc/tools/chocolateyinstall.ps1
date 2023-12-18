$ErrorActionPreference = 'Stop'

$params = @{
   PackageName   = 'redshift-odbc'
   FileType      = 'msi'
   Url           = 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/1.4.52.1000/AmazonRedshiftODBC32-1.4.52.1000.msi'
   Url64bit      = 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/1.5.9.1011/AmazonRedshiftODBC64-1.5.9.1011.msi'
   Checksum      = 'fccd335dbfc0c3ee48d3af244dfc1f32eac29eca4d6dfac4ad8ad8eb8ae835d5'
   Checksum64    = 'b8e64a39b8c71a6997bf23f4979e623471fbda4930c521da91c2c2f4ae338e23'
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
