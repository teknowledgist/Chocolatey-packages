$ErrorActionPreference = 'Stop'

$Bits = Get-OSArchitectureWidth

[array]$key = Get-UninstallRegistryKey -SoftwareName "$env:ChocolateyPackageName*"

if ($key.Count -eq 1) {
   $Folder = Split-Path $key[0].UninstallString
   $DLL = Get-ChildItem $Folder -Filter "*.dll" | Where-Object {$key[0].Name -match "$Bits-[0-9.]+\.dll"}
   try {
      & $env:SystemRoot\System32\regsvr32.exe /u /s $DLL.FullName
      if ($Bits -eq 64) {
         & $env:SystemRoot\SysWoW64\regsvr32.exe /u /s $($DLL.FullName -replace "Hashtab64-","HashTab32-")
      }
   } catch {Throw "HashTab could not be stopped to uninstall.  Try rebooting first."}

   if (Get-Process Explorer -Module | Where-Object {$_.ModuleName -match 'hashtab'}) {
      $locked = $true
      Write-Host "Waiting (up to 20 seconds) for in-use $env:ChocolateyPackageName libraries to be released."
      Write-Host "Please be patient."
      $seconds = 0
   } else { $locked = $false }
   While ($locked) {
      if ($seconds -le 20) {
         Start-Sleep -Seconds 1
         $seconds++
         if (-not (Get-Process Explorer -Module | Where-Object {$_.ModuleName -match 'hashtab'})) {
            $locked = $false
            Write-Host "Libraries unlocked after $seconds seconds."
         }
      } else {
         $locked = $false
         Write-Warning "Libraries not unlocking. Uninstall/upgrade may fail."
         Write-Warning "Make sure no file property windows are open."
      }
   }
}

