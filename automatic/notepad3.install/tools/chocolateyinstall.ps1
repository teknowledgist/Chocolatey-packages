$ErrorActionPreference = 'Stop'

$fileLocation = (Get-ChildItem (Split-Path $MyInvocation.MyCommand.Definition) -Filter '*.zip').FullName

$UnzipDir = Join-Path $env:TEMP "$env:ChocolateyPackageName_$env:ChocolateyPackageVersion"

# Extract zip
Get-ChocolateyUnzip -FileFullPath $fileLocation -Destination $UnzipDir

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileType     = 'EXE' 
   File        = (Get-ChildItem $UnzipDir -filter "*.exe" -Recurse).FullName
  softwareName = "$env:ChocolateyPackageName*"
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
}

Install-ChocolateyInstallPackage @packageArgs
