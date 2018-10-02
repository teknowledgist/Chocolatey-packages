$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipFile = (Get-ChildItem $toolsDir -Filter '*.zip').FullName

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $env:ChocolateyPackageFolder

# Create registry key for Audacity to recognize LAME
Write-Debug 'Setting registry key for LAME location.'
$RegXtra = ''
If (Get-OSArchitectureWidth -Compare 64) {
   $RegXtra = '\Wow6432Node'
}
$RegPath = "HKLM:\SOFTWARE$RegXtra\Lame For Audacity"
New-Item $RegPath -Force | Write-Debug
New-ItemProperty -Path $RegPath -Name 'InstallPath' -Value $env:ChocolateyPackageFolder -force | Write-Debug

