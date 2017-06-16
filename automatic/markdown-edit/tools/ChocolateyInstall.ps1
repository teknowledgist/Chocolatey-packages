$PackageName = 'Markdown Edit'
# Lines to be updated by automatic updater
$Url = 'https://github.com/mike-ward/Markdown-Edit/releases/download/v1.33/MarkdownEditSetup.msi'
$Checksum = 'e67cbc0bdc8215d7fc1fb837da4177eaad562b08d25b75cd22e6a56dafb08d7e'

$OSversion = [version](Get-WmiObject -Class Win32_OperatingSystem).version 
if ($OSversion -eq $null -or $OSversion -lt [Version]'6.2') {
  Write-Host "$PackageName is designed for use with fonts that do not come with this version of Windows." -ForegroundColor Cyan
}

$installArgs = @{
  packageName = $PackageName
  url = $Url
  fileType = 'msi'
  Checksum = $Checksum
  ChecksumType = 'sha256'
  SilentArgs = '/quiet ALLUSERS=1'
  ValidExitCodes = @(0)
}

Install-ChocolateyPackage @installArgs
