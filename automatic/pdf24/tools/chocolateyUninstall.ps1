Remove-Item 'HKLM:\SOFTWARE\Wow6432Node\PDFPrint' -Recurse -Force

[array]$key = Get-UninstallRegistryKey -SoftwareName "PDF24*"

if ($key.Count -eq 1) {
   $key[0].PSChildName
   $GUID = $key[0].PSChildName
   $UninstallArgs = @{
      Statements    = "/x $GUID /qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).Uninstall.log`""
      ExeToRun      = "$env:SystemRoot\SysWow64\msiexec.exe"
      validExitCodes= @(0, 3010, 1605, 1614, 1641)
   }
   Start-ChocolateyProcessAsAdmin @UninstallArgs

} elseif ($key.Count -gt 1) {
   Throw "Multiple installs found.  Could not safely uninstall PDF24!"
} else {
   Write-Host "PDF24 not found.  It may have been uninstalled through other actions."
}

