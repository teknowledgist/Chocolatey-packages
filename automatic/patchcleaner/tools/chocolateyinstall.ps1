$ErrorActionPreference = 'Stop'

$fileLocation = (Get-ChildItem (Split-Path $MyInvocation.MyCommand.Definition) -Filter '*.exe').FullName

$UnzipDir = Join-Path $env:TEMP $env:ChocolateyPackageName

# Extract zip
Get-ChocolateyUnzip -FileFullPath $fileLocation -Destination $UnzipDir

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = "$env:ChocolateyPackageName*"
   fileType       = 'msi'
   File           = (Get-ChildItem $UnzipDir -filter "*.msi" -Recurse).FullName
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

New-Item "$fileLocation.ignore" -Type file -Force | Out-Null

