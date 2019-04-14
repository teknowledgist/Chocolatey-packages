$ErrorActionPreference = 'Stop'

if (Get-ProcessorBits -compare 32) {
   $msg = "SketchUp Make 2017 is 64-bit only.  `n" + 
          'The 2016 release is the last version available for this 32-bit system.'
   Throw $msg
}

$pp = Get-PackageParameters
if ($pp.contains('Keep')) {
   Write-Host 'You wish to keep the 2016 version of Sketchup.' -ForegroundColor Cyan
   Write-Warning 'Note:  Chocolatey will not be able to uninstall the 2016 version of Sketchup.'
} else {
   [array]$Keys = Get-UninstallRegistryKey -SoftwareName 'SketchUp 2016'
   if ($Keys) {
      if ($Keys.Count -gt 1) {
         Write-Warning 'Multiple, previously-installed versions of SketchUp 2016 found.'
         Write-Warning 'They will **not** be uninstalled.'
      } elseif ($Keys.Count -eq 1) {
         $AppID = $Keys[0].UninstallString.split('{')[-1].trim('}')

         $UninstallArgs = @{
            ExeToRun       = 'msiexec.exe'
            Statements     = "/x{$AppID} /qn /norestart"
            ValidExitCodes = @(0)
         }
         Write-Host 'Uninstalling Sketchup v2016.' -ForegroundColor Cyan
         $null = Start-ChocolateyProcessAsAdmin @UninstallArgs
         # The uninstaller starts another process and immediately returns.  
         Get-Process | Where-Object {$_.path -match '.*Temp.*chocolatey.*Au_.exe'} |wait-process
      }
   }
}

$UnzipArgs = @{
   PackageName    = $env:ChocolateyPackageName
   url64          = 'https://www.sketchup.com/sketchup/2017/en/sketchupmake-2017-2-2555-90782-en-x64-exe'
   checksum64     = '9841792F170D803AE95A2741C44CCE38E618660F98A1A3816335E9BF1B45A337'
   checksumType   = 'sha256'
   UnzipLocation  = Join-Path $env:temp "$env:ChocolateyPackageName.$($env:chocolateyPackageVersion)"
}
Install-ChocolateyZipPackage @UnzipArgs

$installFile = Get-ChildItem -Path $UnzipArgs['UnzipLocation'] -Filter *.msi
if ($installFile) {
   $installArgs = @{
      PackageName    = $env:ChocolateyPackageName
      FileType       = 'msi'
      silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" 
      File           = $installFile.fullname
      validExitCodes = @(0,3010)
   }
   Install-ChocolateyInstallPackage @installArgs
} else {
  Write-Warning 'MSI install file not found.'
  throw
}
