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
# Remove any previous installer files
Get-ChildItem $toolsDir -filter *.exe -Recurse | ForEach-Object { Remove-Item $_.fullname -Force }

$ZipFile = Get-ChildItem -Path $toolsDir -Filter "*x$Bitness*.zip" | 
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1 
$ZipArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFile
   Destination    = $toolsDir
}
$null = Get-ChocolateyUnzip @ZipArgs

$InstallerFile = (Get-ChildItem -Path $toolsDir -Filter "*.exe" -Recurse).FullName

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   File           = $InstallerFile
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

$binaries = Get-ChildItem "$toolsDir\*.zip","$toolsdir\*.exe" -Recurse |
               Select-Object -ExpandProperty fullname
foreach ($bin in $binaries) {
   Remove-Item $bin -ea 0 -force
}

