$ErrorActionPreference = 'Stop'

$packageName = 'setacl-studio'
$url32       = 'https://helgeklein.com/files/SetACL-Studio/current/SetACL%20Studio.msi'
$checksum32  = '73BCC9A8D27C070CAA4E2BBD238899ED92A93D0459DB1C3CC8A65E11CA62EF41'
$toolsPath   = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
  packageName            = $packageName
  fileType               = 'MSI'
  url                    = $url32
  checksum               = $checksum32
  checksumType           = 'sha256'
  silentArgs             = '/quiet'
  validExitCodes         = @(0)
  registryUninstallerKey = $packageName
}

Install-ChocolateyPackage @packageArgs


if(!(Test-Path 'HKLM:\SOFTWARE\Helge Klein\SetACL Studio'))
    {
    New-Item 'HKLM:\SOFTWARE\Helge Klein\SetACL Studio' -Force | Out-Null
    New-ItemProperty 'HKLM:\SOFTWARE\Helge Klein\SetACL Studio' -Name 'LicenseKey' -Value 'RUMH5R-PREMM7-W38EA5-QTSQZ1-1HA1A6-CTXHUQ' -PropertyType String -Force | Out-Null

    }
else
    {
    New-ItemProperty 'HKLM:\SOFTWARE\Helge Klein\SetACL Studio' -Name 'LicenseKey' -Value 'RUMH5R-PREMM7-W38EA5-QTSQZ1-1HA1A6-CTXHUQ' -PropertyType String -Force | Out-Null
    }