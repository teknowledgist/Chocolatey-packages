$ErrorActionPreference = 'Stop'

$url        = 'http://www.intusoft.com/demos/ICAP4Demo.zip'
$Checksum   = '6b1ec06e28e8adf63bdd909717f4c059a3757ea9dec90f0f47eac01a9c42d6ad'

$WorkSpace = Join-Path $env:TEMP $env:ChocolateyPackageName

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.zip"
   Url          = $url
   Checksum     = $checkSum
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = $PackedInstaller
   Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$QuietFile  = Join-Path $toolsDir 'ICAP4setup.iss'

$InstallArgs = @{
   PackageName    = $env:ChocolateyPackageName
   File           = (Get-ChildItem $WorkSpace -Filter 'setup.exe' -Recurse).FullName
   fileType       = 'exe'
   silentArgs     = "/S /SMS /f1$QuietFile"
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
