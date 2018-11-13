$ErrorActionPreference = 'Stop'

$Installer = Get-ChildItem (Split-Path $MyInvocation.MyCommand.Definition) -Filter '*.msi'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'msi'
   File           = $Installer.FullName
   silentArgs     = "/qn /norestart /l*v "+
                        "`"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" " +
                        "PREMIUM_MODULES=false CHECK_FOR_NEWS=false CHECK_FOR_UPDATES=false SKIPTHANKSPAGE=Yes DONATE_NOTIFICATION=false"
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs


