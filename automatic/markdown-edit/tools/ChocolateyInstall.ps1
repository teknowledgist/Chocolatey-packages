$PackageName = 'Markdown Edit'
# Lines to be updated by automatic updater
$Url = 'https://github.com/mike-ward/Markdown-Edit/releases/download/v1.35/MarkdownEditSetup.msi'
$Checksum = '234656b63192e7c5042714c557d1df9b208d0c28a2c9a8cee4a0739e144068e1'

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
