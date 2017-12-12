$ErrorActionPreference = 'Stop'

[array]$key = Get-UninstallRegistryKey -SoftwareName "GeoDa*"

if ($key.Count -eq 1) {
   $RemoveProc = Start-Process -FilePath $key[0].UninstallString -ArgumentList '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -PassThru
   $updateId = $RemoveProc.Id
   Write-Debug "Uninstalling old version of GeoDa."
   Write-Debug "Uninstall Process ID:`t$updateId"
   $RemoveProc.WaitForExit()
} elseif ($key.Count -gt 1) {
   Throw "Multiple, previous installs found!  Cannot proceed with install of new version."
}

$Bitness = Get-OSArchitectureWidth

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerFile = (Get-ChildItem -Path $toolsDir -Filter "*$($Bitness)bit.exe").FullName

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   File           = $InstallerFile
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

$exes = Get-ChildItem $toolsDir -filter *.exe -Recurse |select -ExpandProperty fullname
foreach ($exe in $exes) {
   New-Item "$exe.ignore" -Type file -Force | Out-Null
}

