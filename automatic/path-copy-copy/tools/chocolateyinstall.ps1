$ErrorActionPreference = 'Stop'

$packageArgs = @{
  softwareName  = 'Path Copy Copy*'
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url           = 'https://github.com/clechasseur/pathcopycopy/releases/download/14.0/PathCopyCopy14.0.exe'
  Checksum      = '851475cd14e2b7ccef0bb778766affb00cc76512d77f06984aba4373a784c241'
  checksumType  = 'sha256'
  silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

$WarningString = "This installer is known to close the Explorer process.  `n" +
               "If it doesn't automatically restart explorer, type 'explorer' on the `n" +
               'command shell to restart it.'
Write-Warning $WarningString

Install-ChocolateyPackage @packageArgs
