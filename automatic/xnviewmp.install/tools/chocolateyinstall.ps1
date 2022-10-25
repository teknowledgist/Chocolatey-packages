$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$EXEs = Get-ChildItem $toolsDir -Filter '*.exe' | Sort-Object LastWriteTime | 
            Select-Object -Last 2 -ExpandProperty FullName

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   softwareName = "$env:ChocolateyPackageName*"
   fileType     = 'EXE' 
   File         = $EXEs | ? {$_ -notmatch 'x64'}
   File64       = $EXEs | ? {$_ -match 'x64'}
   silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

foreach ($file in $exes) {
   Remove-Item $file -ea 0 -force
}
