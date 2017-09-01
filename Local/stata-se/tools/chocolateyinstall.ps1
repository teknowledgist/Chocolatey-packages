$ErrorActionPreference = 'Stop'

$packageName  = 'stata-se'
$commonName   = 'StataSE'
$LicenseFile  = 'STATA.LIC'  # This license file must be placed in the Tools folder

$v    = '14'
$Bits = Get-ProcessorBits

$InstallArgs = @{
   PackageName    = $packageName
   url            = "\\Server\share\Stata\SetupStata$v.exe"
   Checksum       = 'F561EA1D7DB8EABA73B65EA92B5D4A941660D7B6FD86A2AD313234D57B2E8468'
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

$shortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) "$commonName $v.lnk"
Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $Stata


