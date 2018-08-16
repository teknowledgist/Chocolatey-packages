$ErrorActionPreference = 'Stop'
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipPath = (Get-ChildItem -Path $toolsDir -filter '*.zip').FullName

# Extract zip
$UnZipPath = Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination (Join-Path $env:TEMP $env:ChocolateyPackageName)

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = (Get-ChildItem -Path $UnZipPath -filter '*.exe').FullName
   silentArgs     = "/silent /Extract /dir=`"$env:ChocolateyPackageFolder`""
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

Get-ChildItem -Path $env:ChocolateyPackageFolder -filter 'setup.exe' -Recurse | 
   ForEach-Object { $null = New-Item "$($_.FullName).ignore" -Type file -Force }


