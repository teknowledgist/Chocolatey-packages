$packageName = 'fastcopy.install'
$url32       ='http://ftp.vector.co.jp/68/61/2323/FastCopy330.zip'
$checkSum32  = 'c67bd82f9847d759b1fe114934ca724ead7f49a115764dff5473437a2bf5e926'
$url64       ='http://ftp.vector.co.jp/68/61/2323/FastCopy330_x64.zip'
$checkSum64  = 'b66b8987d52d3d1a2cfad881f435d8d6cef48a9b72295ab2b2447b7550eec842'

$DownloadArgs = @{
   PackageName         = $packageName
   FileFullPath        = "$env:TEMP\$packageName\Download.zip"
   Url                 = $url32
   Url64bit            = $url64
   Checksum            = $checkSum32
   Checksum64          = $checkSum64
   ChecksumType        = 'sha256'
   GetOriginalFilename = $true
}

# Download zip
$ZipPath = Get-ChocolateyWebFile @DownloadArgs
 
# Extract zip
Get-ChocolateyUnzip $ZipPath (Split-Path $ZipPath)

$UserArguments = @{}

# Parse the packageParameters using good old regular expression
if ($env:chocolateyPackageParameters) {
   $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
   $option_name = 'option'
   $value_name = 'value'
 
   if ($env:chocolateyPackageParameters -match $match_pattern ){
      $results = $env:chocolateyPackageParameters | Select-String $match_pattern -AllMatches
      $results.matches | % {
         $UserArguments.Add(
            $_.Groups[$option_name].Value.Trim(),
            $_.Groups[$value_name].Value.Trim()
         )
      }
      if ($UserArguments.ContainsKey('NoSubs')) {
         Write-Host 'You want FastMenu options directly in context menus (not in submenus).'
         $NoSubs = 'NoSubs'
      }
   } else { Throw 'Package Parameters were found but were invalid (REGEX Failure)' }
} else { Write-Debug 'No Package Parameters Passed in' }

# Win7 complains the installer didn't run correctly.  This will prevent that.
Set-Variable __COMPAT_LAYER=!Vista

& AutoHotKey $(Join-Path $env:ChocolateyPackageFolder 'tools\chocolateyInstall.ahk') $(Join-Path (Split-Path $ZipPath) 'setup.exe') $NoSubs


