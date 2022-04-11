$ErrorActionPreference = 'Stop'

$pp = Get-PackageParameters

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   url            = 'http://zabkat.com/dl/xplorer2_setup.exe'
   url64          = 'http://zabkat.com/dl/xplorer2_setup64.exe'
   softwareName   = 'xplorer² Pro*'
   checksum       = 'a378c55e744367ceb2ebadb60eb8fb4d4c79789c7ad7b75a1f3918ccf4bb758a'
   checksum64     = '4e9efad0d690097977e7801f5031446316c23fd83c47fcce5921828252f4eb8e'
   checksumType   = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

