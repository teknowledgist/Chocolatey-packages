$installArgs = @{
  packageName = 'markdown-edit'
  url = 'https://github.com/mike-ward/Markdown-Edit/releases/download/v1.29.1/MarkdownEditSetup.msi'
  fileType = 'msi'
  Checksum = 'b538d92192412aa072ab11f98bcf9ed31bd2c9c5'
  ChecksumType = 'sha1'
  SilentArgs = '/quiet ALLUSERS=1'
  ValidExitCodes = @(0)
}

Install-ChocolateyPackage @installArgs
