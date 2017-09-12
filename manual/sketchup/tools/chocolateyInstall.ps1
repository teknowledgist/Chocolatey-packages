$ErrorActionPreference = 'Stop'
$packageName = 'sketchup'
$version = '2016.1.1449'

$UnzipArgs = @{
   PackageName    = $packageName
   url            = 'https://dl.trimble.com/sketchup/2016/en/SketchUpPro-2016-1-1450-80430-en-x86.exe'
   url64          = 'https://dl.trimble.com/sketchup/2016/en/SketchUpPro-2016-1-1449-80430-en-x64.exe'
   checksum       = 'B0DAA3C6056FA72BE006DDB9DA87CF908336F6E948A0A131B2CDF10BADF6EEA2'
   checksum64     = 'D4632178EDD8DF013C27FC752188516C2325942FA074F432340131E0479DC98C'
   checksumType   = 'sha256'
   UnzipLocation  = Join-Path $env:temp $packageName
}
Install-ChocolateyZipPackage @UnzipArgs

$installFile = Get-ChildItem -Path $UnzipArgs['UnzipLocation'] -Filter *.msi
if ($installFile) {
   $installArgs = @{
      PackageName    = $packageName
      FileType       = 'msi'
      silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
      File           = $installFile.fullname
      validExitCodes = @(0,3010)
   }
   Install-ChocolateyInstallPackage @installArgs

} else {
  Write-Warning "MSI install file not found."
  throw
}

$UserArguments = @{}

# Parse the packageParameters using good old regular expression
if ($env:chocolateyPackageParameters) {
   $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
   $option_name = 'option'
   $value_name = 'value'
 
   if ($env:chocolateyPackageParameters -match $match_pattern ){
      $results = $env:chocolateyPackageParameters | Select-String $match_pattern -AllMatches
      $results.matches | ForEach-Object {
      $UserArguments.Add(
         $_.Groups[$option_name].Value.Trim(),
         $_.Groups[$value_name].Value.Trim())
      }
   }

   $LicenseFileDestination = Join-Path $env:ProgramFiles "$packageName\$packageName $(([version]$version).major)\activation_info.txt"

   if ($UserArguments.ContainsKey('ActivationFile')) {
      Write-Host 'You provided a license file path.'
      $ActFilePath = $UserArguments.ActivationFile

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
   } elseif ($UserArguments.ContainsKey('SN') -and $UserArguments.ContainsKey('AuthCode')) {
      Write-Host 'You provided a serial number and authorization code.'
      Write-Host 'The license will be set to "allow re-activation"' -ForegroundColor Cyan
      Write-Host 'See here for info: https://help.sketchup.com/en/article/3000285' -ForegroundColor Cyan
      $FileString = @"
{
"serial_number":"$($UserArguments.SN)",
"auth_code":"$($UserArguments.AuthCode)",
"allow_reactivation":"true"
}
"@
      $FileString | Out-File -FilePath $LicenseFileDestination -Force
   } else {
   Throw 'Package Parameters were found but were invalid (REGEX Failure)'
   }
} else {
   Write-Debug 'No Package Parameters Passed in.'
}

