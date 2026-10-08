$ErrorActionPreference = 'Stop'
  
$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Anaconda3'
   fileType      = 'EXE'
   url64bit      = 'https://repo.anaconda.com/archive/Anaconda3-2026.07-1-Windows-x86_64.exe'
   checksum64    = 'b545f4bd8ab3bf32d99002a0779a887668ebfe479ee32ecbf060375670d5ee09'
   checksumType  = 'sha256'
   validExitCodes= @(0)
}

$pp = Get-PackageParameters

$ToolsDir = Get-ToolsLocation
$CondaPath = "$ToolsDir\Anaconda3\Scripts\conda.exe"
$RunInstall = $true

if (test-path $CondaPath) {
   Write-Verbose "Checking for previous Anaconda installs."
   [array]$key = Get-UninstallRegistryKey -SoftwareName 'Anaconda3*'
   # Anaconda is/was installed already. Have it update itself, or start fresh?
   if ($pp['Fresh']) {
      # If starting fresh, need to uninstall (possibly non-Chocolatey installed)
      if ($key.Count -eq 1) {
         $UninstallArgs = @{
            ExeToRun       = $key[0].UninstallString
            Statements     = '/S'
            ValidExitCodes = @(0)
         }
         $null = Start-ChocolateyProcessAsAdmin @UninstallArgs
         # The uninstaller starts another process and immediately returns.  
         Write-Warning "Uninstalling Anaconda v$($key[0].DisplayVersion) in preparation for a requested 'Fresh' install."
         Get-Process | Where-Object { $_.path -match '\\Un\.exe' } | wait-process
         # Fresh is fresh
         Remove-Item "$ToolsDir\Anaconda3" -Recurse -Force -ErrorAction SilentlyContinue
      }
      elseif ($key.Count -eq 0) {
         Write-Warning "Anaconda is not installed, but installation/config files remain in $ToolsDir.\r\n   Reinstallation will be attempted."
      }
      elseif ($key.Count -gt 1) {
         Write-Warning "$($key.Count) matches found!"
         Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
         Throw "A 'Fresh' install is not possible with multiple existing installs."
      }
   } else { 
      $RunInstall = $false
      # Don't clean re-install. Have Anaconda update itself
      # The goal is an open install, so we want the "_anaconda_depends" metapackage (i.e. without pinned package versions).
      #    See: https://www.anaconda.com/docs/getting-started/advanced-install/install-metapackage#specific-version
      Write-Warning "Attempting Conda install of Anaconda v$(([version]$env:chocolateypackageversion).tostring(2)) metapackage."

      $psi = New-object System.Diagnostics.ProcessStartInfo 
      $psi.CreateNoWindow = $true 
      $psi.UseShellExecute = $false 
      $psi.RedirectStandardOutput = $true 
      $psi.RedirectStandardError = $true 
      $psi.FileName = "$CondaPath" 
      $psi.Arguments = @("tos accept & install _anaconda_depends=$(([version]$env:chocolateypackageversion).tostring(2)) --yes --quiet") 
      $process = New-Object System.Diagnostics.Process 
      $process.StartInfo = $psi 
      [void]$process.Start()
      $output = $process.StandardOutput.ReadToEnd() 
      $process.WaitForExit() 
      Write-Verbose $output

      # Now, update the registry to display the more correct Anaconda distribution version
      $TargetKey = $key | Where-Object {$_.UninstallString -match ("$ToolsDir\Anaconda3").replace('\','\\')}
      $DisplayVersion = get-itemproperty -Path $TargetKey.pspath | Select-Object -ExpandProperty DisplayVersion

      if (($env:ChocolateyPackageVersion.tochararray() -ceq '.').count -ge 2) {
         $NewDisplayVersion = $env:ChocolateyPackageVersion -replace '(.*)\.(.*)','$1-$2'
      }
      $NewKeyName = $TargetKey.pspath.split('\')[-1] -replace $DisplayVersion, $NewDisplayVersion
      $NewDisplayName = (Get-ItemProperty -Path $TargetKey.pspath | Select-Object -ExpandProperty DisplayName) -replace $DisplayVersion, $NewDisplayVersion

      Set-ItemProperty $TargetKey.PSPath -Name 'DisplayName' -Value $NewDisplayName
      Set-ItemProperty $TargetKey.PSPath -Name 'DisplayVersion' -Value $NewDisplayVersion
      Rename-Item $TargetKey.PSPath -NewName $NewKeyName
   }
} 

if ($RunInstall) {
   # For an initial install or a "Fresh" install after removal
   if (!$pp['JustMe']) { $T = 'AllUsers' } 
   else { 
      Write-Host 'You have opted to install for the current user only.' -ForegroundColor Cyan
      $T = 'JustMe'
   }

   if (!$pp['DoNotRegister']) { $R = '1' } 
   else { 
      Write-Host 'You have opted to NOT register this installation of Python.' -ForegroundColor Cyan
      $R = '0'
   }

   if (!$pp['AddToPath']) { $P = '0' } 
   else { 
      Write-Host 'You have opted to add Anaconda Python to the path.' -ForegroundColor Cyan
      if ($T -eq 'AllUsers') {
         Write-Warning 'Adding to the path is disabled for AllUser installs as of the 2022.05 release!'
      }
      $P = '1'
   }

   if (!$pp['D']) {
      $D = Join-Path $ToolsDir 'Anaconda3'
   }
   else {
      if (!(Test-Path $pp['D'])) {
         Write-Error "`nThe destination ('/D') parameter, '$($pp['D'])' is not an available path!"
      }
      else {
         Write-Host "You wish to install to the path: $($pp['D'])" -ForegroundColor Cyan
         $D = Join-Path $pp['D'] 'Anaconda3'
      }
   }
  
   $InstallArgs.add('silentArgs', "/S /InstallationType=$T /RegisterPython=$R /AddToPath=$P /D=$D")

   Write-Warning 'The Anaconda3 installation can take a long time (up to 30 minutes).'
   Write-Warning 'Please be patient and let it finish.'
   Write-Warning 'If you want to verify the install is running, you can watch the installer process in Task Manager'

   Install-ChocolateyPackage @InstallArgs
}