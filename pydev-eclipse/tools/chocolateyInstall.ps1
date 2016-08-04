$ErrorActionPreference = 'Stop'  # stop on all errors

$ZipArgs = @{
   PackageName = 'pydev'
   Url = 'https://sourceforge.net/projects/pydev/files/latest/download'
   Checksum = 'F8C8258431CDC4B84D4D346902B32F67BF6519D7'
   ChecksumType = 'sha1'
}

$HostPackage = 'eclipse'
$HostPackageLocation = "$env:ChocolateyInstall\lib\$HostPackage"
$HostUnzipLog = Get-ChildItem $HostPackageLocation -Filter "$HostPackage*.zip.txt"
If ($HostUnzipLog) {
   $HostInstallLocation = Get-Content $HostUnzipLog.FullName | Select-Object -First 1
} else {
   throw "Chocolatey package $HostPackage install location not found!"
}

$ZipArgs.add('UnzipLocation', (Get-ChildItem $HostInstallLocation -filter dropins -Recurse).fullname)

Install-ChocolateyZipPackage @ZipArgs
