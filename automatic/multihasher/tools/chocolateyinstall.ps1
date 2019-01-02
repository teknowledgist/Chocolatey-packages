$ErrorActionPreference = 'Stop'

$Url         = 'https://drive.google.com/uc?export=download&id=0B0N7Pu7pijFBRVhQZWJtNGRrMHM'
$Checksum    = '9cf08b4219e523f291a0888da39194de4de7af00e852dff0c3f429fe918bf073'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = Join-Path $WorkSpace "$env:ChocolateyPackageName.zip"
   Url            = $Url
   Checksum       = $checkSum
   ChecksumType   = 'sha256'
   GetOriginalFileName = $true
}

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = $PackedInstaller
   Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   File           = Join-Path $WorkSpace "$env:ChocolateyPackageName Setup.exe"
   fileType       = 'EXE'
   silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs


