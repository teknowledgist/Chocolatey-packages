$ErrorActionPreference = 'Stop'

$packageName  = 'stata-se'
$commonName   = 'StataSE'
$LicenseFile  = 'STATA.LIC'  # This license file must be placed in the Tools folder

$v    = '15'
$Bits = Get-ProcessorBits

$InstallArgs = @{
   PackageName    = $packageName
   url            = "\\Server\share\Stata\SetupStata$v.exe"
   Checksum       = 'A9EA2863D69E93BD7648A19ED2D05283165C566869FDE1D58090CCF8CA92C713'
   ChecksumType   = 'sha256'
   FileType       = 'exe'
   SilentArgs     = "/qb ADDLOCAL=Ado,Core,$commonName$Bits"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

[array]$key = Get-UninstallRegistryKey -SoftwareName "Stata $v"

# Stata updates itself, but unprivileged users cannot initiate that.  This will bring
#   the current install up-to-date.  Future updates will need to handled elsewhere.
if ($key.Count -eq 1) {
   $installDir = $key[0].InstallLocation

   Write-Debug "Copying license file to $installDir."
   $LicensePath = Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) $LicenseFile
   Copy-Item $LicensePath $installDir -Force

   Write-Host "Updating Stata components." -ForegroundColor Cyan
   $Stata = Join-Path $installDir "$commonName-$Bits.exe"
   $updateProc = Start-Process -FilePath $Stata -ArgumentList "/e /i update all" -PassThru
   $updateId = $updateProc.Id
   Write-Debug "$Stata update start time:`t$($updateProc.StartTime.ToShortTimeString())"
   Write-Debug "Process ID:`t$updateId"
   $updateProc.WaitForExit()
} elseif ($key.Count -gt 1) {
   Write-Host "Multiple installs found!  Can't auto-license or update $commonName" -ForegroundColor Red
} else {
   Throw "$commonName install not found!  Can't auto-license or update $commonName"
}

$shortcut = Join-Path $env:PUBLIC "Desktop\$commonName $v.lnk"
Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $Stata


