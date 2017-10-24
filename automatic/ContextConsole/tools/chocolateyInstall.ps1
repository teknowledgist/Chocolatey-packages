$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   FileFullPath   = (Get-ChildItem (Split-Path $MyInvocation.MyCommand.Definition) -Filter "*.exe").FullName
   silentArgs     = '/quiet'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

