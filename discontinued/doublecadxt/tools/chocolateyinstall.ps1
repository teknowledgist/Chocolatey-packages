$ErrorActionPreference = 'Stop'

# Due to silent arg quoting complexities only log the inner-MSI install
#   if the Temp directory path contains a space
if ($env:Temp -notmatch ' ') {
  $MSILog = "/l*v $($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log"
} else { $MSILog = '' }

$SN = 'DCAK-5988-0287-0300-3180'  # This is public: http://download.cnet.com/DoubleCAD-XT/3000-18496_4-10907980.html

$InstallArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   url            = 'https://s3.us-west-1.wasabisys.com/imsi.downloads.was/downloads/DoubleCAD_XT_v5.exe'
   Checksum       = '8033bd9b706b2f87159c24c15ed7c432b7aa4cfc43356f12ad7066363e9daee9'
   ChecksumType   = 'SHA256'
   silentArgs     = "/s /a /s /v`"/qn /norestart $MSILog ALLUSERS=1 PIDKEY=$SN`""
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @InstallArgs
