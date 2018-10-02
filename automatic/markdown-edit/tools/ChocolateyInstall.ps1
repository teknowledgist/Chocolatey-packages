$PackageName = 'Markdown Edit'
# Lines to be updated by automatic updater
$Url = 'https://github.com/mike-ward/Markdown-Edit/releases/download/v1.34/MarkdownEditSetup.msi'
$Checksum = 'd237e53f1ededce4851409bae79a8f610cc9e03cd91ca96bd5280536d95602a7'

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
