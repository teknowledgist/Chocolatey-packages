$ErrorActionPreference = 'Stop'

# Remove possible previous install
Write-Warning 'Checking for previous install.'
[array]$key = Get-UninstallRegistryKey -SoftwareName 'marcedit*'
$SameID = $false
if ($key.Count -le 2) {
   if ($key.Count -eq 2) {
      $First = $key[0].UninstallString -replace '.*\{(.*)}.*','$1'
      $Second = $key[1].UninstallString -replace '.*\{(.*)}.*', '$1'
      if ($first -eq $second) {
         $SameID = $true
      }
   }
   If ($key.Count -eq 1 -or $SameID) {
      $UninstallArgs = ($key[0].UninstallString -replace '.*msiexec\.exe /i','/x') + " /qn /norestart"
      $RemoveProc = Start-Process -FilePath "$env:SystemRoot\System32\msiexec.exe" -ArgumentList $UninstallArgs -PassThru
      $updateId = $RemoveProc.Id
      Write-Debug 'Uninstalling old version of marcedit.'
      Write-Debug "Uninstall Process ID:`t$updateId"
      $RemoveProc.WaitForExit()
   } 
}
if (($key.Count -ge 2) -and (-not $SameID)) {
   Write-Warning 'Multiple, previous installs found!  This package will attempt to install the latest version, but no previous installs will be removed.'
}

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = "$env:ChocolateyPackageName*"
   fileType       = 'EXE'
   URL            = 'https://marcedit.reeset.net/software/marcedit75/MarcEdit_7_8_mixed.exe'
   Checksum       = '85285CE5B7F47CB3A05805C541D59A6AACC59C91EDDFE2F30221ADAB5F4FADA6'
   ChecksumType   = 'sha256'
   silentArgs    = " /exenoui /noprereqs /q NOAUTOUPDATE=1"
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 

