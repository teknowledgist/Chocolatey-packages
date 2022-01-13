$ErrorActionPreference = 'Stop'

if (Get-ProcessorBits -compare 64) {
   $toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
   $fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe').FullName

   $packageArgs = @{
      packageName    = $env:ChocolateyPackageName
      fileType       = 'EXE'
      file           = $fileLocation
      softwareName   = "$env:ChocolateyPackageName*"
      silentArgs     = '/S'
      validExitCodes = @(0)
   }
   Install-ChocolateyInstallPackage @packageArgs

   Remove-Item $fileLocation -ea 0 -force

} else {
   Throw 'There is no RIOT installer other than for 64-bit systems, so RIOT cannot be installed/upgraded on this computer.'
}
