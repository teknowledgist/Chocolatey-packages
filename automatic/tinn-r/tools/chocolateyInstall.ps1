$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerFile = (Get-ChildItem -Path $toolsDir -Filter "*.exe").FullName

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $InstallerFile
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR="C:\Program Files\Tinn-R" /NOICONS=0'
   validExitCodes = @(0)
}

$UserArguments = Get-PackageParameters

if ($UserArguments['Default']) {
   Write-Host 'You requested that the default file-types open in Tinn-R.'
} else {
   $InstallArgs.silentArgs += ' /Tasks='
}

Install-ChocolateyInstallPackage @InstallArgs

$exes = Get-ChildItem $toolsDir -filter *.exe -Recurse |select -ExpandProperty fullname
foreach ($exe in $exes) {
   New-Item "$exe.ignore" -Type file -Force | Out-Null
}
