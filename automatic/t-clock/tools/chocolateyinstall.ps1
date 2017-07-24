$ErrorActionPreference = 'Stop'; # stop on all errors

$Version = '2.4.3.471'

$packageArgs = @{
  url           = 'https://github.com/White-Tiger/T-Clock/releases/download/v2.4.3%23471-beta/T-Clock.7z'
  checksum      = '16054119b2a21afdb2fe028ce776c3cd02b2d31a4cde6d9f0574e31a405d8d15'
  checksumType  = 'sha256'
  unzipLocation = Join-Path (Split-Path (Split-Path $MyInvocation.MyCommand.Definition)) "v$Version"
  packageName   = $env:ChocolateyPackageName
}

Install-ChocolateyZipPackage @packageArgs

$exes = Get-ChildItem $packageArgs.UnzipLocation -filter *.exe -Recurse |select -ExpandProperty fullname
foreach ($exe in $exes) {
   if ($exe -notmatch 'clock(64)?.exe$') {
      New-Item "$exe.ignore" -Type file -Force | Out-Null
   }
}
