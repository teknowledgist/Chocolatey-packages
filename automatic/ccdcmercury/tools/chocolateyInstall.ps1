$ErrorActionPreference = 'Stop'

# remove the old version if installed
[array]$key = Get-UninstallRegistryKey -SoftwareName "Mercury"

if ($key.Count -eq 1) {
   $RemoveProc = Start-Process -FilePath $key[0].UninstallString -ArgumentList '--mode unattended' -PassThru
   $updateId = $RemoveProc.Id
   Write-Debug "Uninstalling old version of CCDC Mercury."
   Write-Debug "Uninstall Process ID:`t$updateId"
   $RemoveProc.WaitForExit()
} elseif ($key.Count -gt 1) {
   Throw "Multiple, previous installs found!  Cannot proceed with install of new version."
}

If (Get-OSArchitectureWidth -Compare 64) {
   $InstallDir = Join-Path ${env:ProgramFiles(x86)} "\CCDC\Mercury $env:ChocolateyPackageVersion"
} else {
   $InstallDir = Join-Path $env:ProgramFiles "\CCDC\Mercury $env:ChocolateyPackageVersion"
}

$InstallArgs = @{
   packageName    = 'ccdcmercury'
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName $env:ChocolateyPackageVersion*"
   url            = 'https://downloads.ccdc.cam.ac.uk/Mercury/4.1.2/mercurystandalone-4.1.2-windows-installer.exe'
   checksumType   = 'sha256'
   checksum       = '6e443b4cc34d48a6a1d389e1007a03929c61724886a5eb712813668b3940d77e'
   silentArgs     = '--mode unattended --prefix "' + $InstallDir + '"'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

