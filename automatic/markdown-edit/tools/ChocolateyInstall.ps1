# Lines to be updated by automatic updater
$Url = 'https://github.com/mike-ward/Markdown-Edit/releases/download/v1.32/MarkdownEditSetup.msi'
$Checksum = '67e747bc342fc6b42d6bf6ba043acd6e517f2df8140e0853923e5c0b96b961a4'

$installArgs = @{
  packageName = 'markdown-edit'
  url = $Url
  fileType = 'msi'
  Checksum = $Checksum
  ChecksumType = 'sha256'
  SilentArgs = '/quiet ALLUSERS=1'
  ValidExitCodes = @(0)
}

Install-ChocolateyPackage @installArgs
