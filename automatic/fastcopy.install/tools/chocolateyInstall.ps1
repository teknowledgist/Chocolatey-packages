$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipPath = (Get-ChildItem -Path $toolsDir -filter '*_x64.zip').FullName

if (get-OSArchitectureWidth 32) {
   $ZipPath = $ZipPath -replace '_x64',''
}

# Extract zip
Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination (Join-Path $env:TEMP "$ChocolateyPackageName")

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

& AutoHotKey $(Join-Path $env:ChocolateyPackageFolder 'tools\chocolateyInstall.ahk') $(Join-Path $env:TEMP "$ChocolateyPackageName\setup.exe") $NoSubs


