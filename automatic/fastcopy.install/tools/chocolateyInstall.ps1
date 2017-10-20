$packageName = 'fastcopy.install'
$url32       ='http://ftp.vector.co.jp/69/28/2323/FastCopy332.zip'
$checkSum32  = '801b133519ec7779ac344bc5693e4cade51a3c7eae696e9f527eef71be440e55'
$url64       ='http://ftp.vector.co.jp/69/28/2323/FastCopy332_x64.zip'
$checkSum64  = 'b3319d65e89570f521b8abe6a5aaf5ba7cd9b1e14be8dbe18e119b924fefd935'

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


