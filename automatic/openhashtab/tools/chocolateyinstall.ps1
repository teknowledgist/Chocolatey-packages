$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerFile = Get-ChildItem -Path $toolsDir -Filter "*.exe" |
                     Sort-Object LastWriteTime | 
                     Select-Object -ExpandProperty FullName -Last 1

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   File           = $InstallerFile
   silentArgs     = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /ALLUSERS /RESTARTEXITCODE=3010 /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes = @(0,3010)
}
Install-ChocolateyInstallPackage @InstallArgs

$exes = Get-ChildItem $toolsDir -filter *.exe -Recurse |select -ExpandProperty fullname
foreach ($exe in $exes) {
   Remove-Item $exe -ea 0 -force
}
