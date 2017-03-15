$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName   = 'pydev-eclipse-java-neon'
$Version       = '5.1.2'
$Url           = "https://sourceforge.net/projects/pydev/files/pydev/PyDev%20$Version/PyDev%20$Version.zip/download"
$HostPackage   = 'eclipse-java-neon'

$ZipArgs = @{
   PackageName   = $packageName
   Url           = $Url
   Checksum      = 'F8C8258431CDC4B84D4D346902B32F67BF6519D7'
   ChecksumType  = 'sha256'
   UnzipLocation = Join-Path $env:chocolateyPackageFolder "PyDev$Version"
}

Install-ChocolateyZipPackage @ZipArgs

$HostPackageLocation = "$env:ChocolateyInstall\lib\$HostPackage"
$HostUnzipLog = Get-ChildItem $HostPackageLocation -Filter "$HostPackage*.zip.txt"
If ($HostUnzipLog) {
   $HostInstallLocation = Get-Content $HostUnzipLog.FullName | Select-Object -First 1
} else {
   throw "Chocolatey package $HostPackage install location not found!"
}

$DropIns = (Get-ChildItem $HostInstallLocation -Directory -filter dropins -Recurse).fullname
$LinkFile = Join-Path $DropIns "$PyDev$Version.link"

("path=" + $env:chocolateyPackageFolder ) -replace '\\', '/' | Out-File -Encoding ASCII
