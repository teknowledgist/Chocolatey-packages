$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerFile = (Get-ChildItem -Path $toolsDir -Filter "*.exe").FullName

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   File           = $InstallerFile
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

$WarningString = "This installer is known to close the Explorer process.  `n" +
               "If it doesn't automatically restart explorer, type 'explorer' on the `n" +
               'command shell to restart it.'
Write-Warning $WarningString

Install-ChocolateyInstallPackage @InstallArgs

$exes = Get-ChildItem $toolsDir -filter *.exe -Recurse |select -ExpandProperty fullname
foreach ($exe in $exes) {
   New-Item "$exe.ignore" -Type file -Force | Out-Null
}
