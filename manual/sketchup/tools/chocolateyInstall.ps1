$ErrorActionPreference = 'Stop'

if (Get-ProcessorBits -compare 32) {
   $msg = "SketchUp Make/Pro 2017 is 64-bit only.  `n" + 
          "The 2016 release is the last version available for this 32-bit system."
   Throw $msg
   Return
}

$pp = Get-PackageParameters
if ($pp.contains('Keep')) {
   Write-Host "You wish to keep the 2016 version of Sketchup." -ForegroundColor Cyan
   Write-Warning "Note:  Chocolatey will not be able to uninstall the 2016 version of Sketchup."
} else {
   [array]$Keys = Get-UninstallRegistryKey -SoftwareName "SketchUp 2016"
   if ($Keys) {
      if ($Keys.Count -gt 1) {
         Write-Warning "Multiple, previously-installed versions of SketchUp 2016 found."
         Write-Warning "They will **not** be uninstalled."
      } elseif ($Keys.Count -eq 1) {
         $AppID = $Keys[0].UninstallString.split('{')[-1].trim('}')

         $UninstallArgs = @{
            ExeToRun       = "msiexec.exe"
            Statements     = "/x{$AppID} /qn /norestart"
            ValidExitCodes = @(0)
         }
         Write-Host "Uninstalling Sketchup v2016." -ForegroundColor Cyan
         $null = Start-ChocolateyProcessAsAdmin @UninstallArgs
         # The uninstaller starts another process and immediately returns.  
         Get-Process | Where-Object {$_.path -match '.*Temp.*chocolatey.*Au_.exe'} |wait-process
      }
   }
}

# Look here for older versions:
#    https://help.sketchup.com/en/downloading-older-versions
$UnzipArgs = @{
   PackageName    = $env:ChocolateyPackageName
   url64          = 'https://www.sketchup.com/sketchup/2017/en/sketchuppro-2017-2-2555-90782-en-x64-exe'
   checksum64     = '30fddf0c7e78c1fd491687d569eab21449f1fae8a72da1ddccb8a03b495d70ea'
   checksumType   = 'sha256'
   UnzipLocation  = Join-Path $env:temp "$env:ChocolateyPackageName.$($env:chocolateyPackageVersion)"
}
Install-ChocolateyZipPackage @UnzipArgs

$installFile = Get-ChildItem -Path $UnzipArgs['UnzipLocation'] -Filter *.msi
if ($installFile) {
   $installArgs = @{
      PackageName    = $env:ChocolateyPackageName
      FileType       = 'msi'
      silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
      File           = $installFile.fullname
      validExitCodes = @(0,3010)
   }
   Install-ChocolateyInstallPackage @installArgs

} else {
  Write-Warning 'MSI install file not found.'
  throw
}

If ($pp.count) {
   $LicenseFileDestination = Join-Path $env:ProgramFiles "$env:ChocolateyPackageName\$env:ChocolateyPackageName $(([version]$env:chocolateyPackageVersion).major)\activation_info.txt"

   if ($pp.contains('ActivationFile')) {
      Write-Host 'You provided a license file path.'
      $ActFilePath = $pp['ActivationFile']

      $LicenseArgs = @{
         packageName  = 'SketchupLicense'
         fileFullPath = $LicenseFileDestination
         url          = ([System.Uri]$ActFilePath).AbsoluteUri
      }
      if (([System.Uri]$ActFilePath).Scheme -eq 'file' -and 
               (-not (Test-Path ([System.Uri]$ActFilePath).LocalPath))) {
         $msg = "***No license found at $ActFilePath.***`n" + 
               "***You will need to manually copy an 'activation_info.txt' file to the " + 
               "SketchUp installation directory.***`n"
         Write-Warning $msg 
      } else { Get-ChocolateyWebFile @LicenseArgs }
   } elseif ($pp.contains('SN') -or $pp.contains('AuthCode')) {
      if ($pp.contains('SN') -and $pp.contains('AuthCode')) {
         Write-Host 'You provided a serial number and authorization code.'
         Write-Host 'The license will be set to "allow re-activation"' -ForegroundColor Cyan
         Write-Host 'See here for info: https://help.sketchup.com/en/article/3000285' -ForegroundColor Cyan
         $FileString = @"
{
"serial_number":"$($pp['SN'])",
"auth_code":"$($pp['AuthCode'])",
"allow_reactivation":"true"
}
"@
         $FileString | Out-File -FilePath $LicenseFileDestination -Force
      } else {
         Write-Warning 'The Serial Number and Authorization Code must *both* be provided.'
         Write-Warning "You will need to manually register Sketchup Pro $env:chocolateyPackageVersion"
      }
   }
} else {
   Write-Debug 'No Package Parameters Passed in.'
}

