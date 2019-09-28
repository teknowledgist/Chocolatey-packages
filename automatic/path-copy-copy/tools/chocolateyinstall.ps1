$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerFile = (Get-ChildItem -Path $toolsDir -Filter "*.exe").FullName

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   File           = $InstallerFile
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /NOCLOSEAPPLICATIONS /RESTARTEXITCODE=3010'
   validExitCodes = @(0,3010)
}

Install-ChocolateyInstallPackage @InstallArgs

$exes = Get-ChildItem $toolsDir -filter *.exe -Recurse |select -ExpandProperty fullname
foreach ($exe in $exes) {
   New-Item "$exe.ignore" -Type file -Force | Out-Null
}
