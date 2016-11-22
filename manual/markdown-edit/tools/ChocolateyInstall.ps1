$installArgs = @{
  packageName = 'markdown-edit'
  url = 'https://github.com/mike-ward/Markdown-Edit/releases/download/v1.31/MarkdownEditSetup.msi'
  fileType = 'msi'
  Checksum = 'B0B3A7D4AE56EBE6769EFB1667617FC2EAA683446EFE2ED97811D1825D641A07'
  ChecksumType = 'sha256'
  SilentArgs = '/quiet ALLUSERS=1'
  ValidExitCodes = @(0)
}

Install-ChocolateyPackage @installArgs
