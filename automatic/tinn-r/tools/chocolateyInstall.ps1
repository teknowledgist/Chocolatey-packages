$ErrorActionPreference = 'Stop'

$packageName = 'tinn-r'
$URL         = 'https://sourceforge.net/projects/tinn-r/files/latest/download'
$Checksum    = '148a63769f9b794a5df5938253d8da763e4525accb35e1229599ed3165395550'


$InstallArgs = @{
   packageName    = $packageName
   installerType  = 'exe'
   url            = $url
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR="C:\Program Files\Tinn-R" /NOICONS=0'
   Checksum       = $Checksum
   ChecksumType   = 'sha256'
   validExitCodes = @(0)
}

$UserArguments = Get-PackageParameters

if ($UserArguments['Default']) {
   Write-Host 'You requested that the default file-types open in Tinn-R.'
} else {
   $InstallArgs.silentArgs += ' /Tasks='
}

Install-ChocolateyPackage @InstallArgs
