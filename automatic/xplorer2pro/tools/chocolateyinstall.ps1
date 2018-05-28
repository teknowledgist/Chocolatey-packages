$ErrorActionPreference = 'Stop'

$pp = Get-PackageParameters

If (-not $pp.count) {
   Write-Host 'xplorer² will install with default options.'
   $SilentArgs = '/S'  # /S uses all default options -- some of which require re-install to set.
} else {
   if (-not $pp.contains("Icon")) {
      $ahkArgs += 'D'        # Desktop icon is the default
   } elseif ($pp["Icon"] -eq 1) {
      Write-Host 'You requested an xplorer² desktop icon.'
      $ahkArgs += 'D'
   } else {
      Write-Host 'You requested NO xplorer² desktop icon.'
   }
   if (-not $pp.contains("Skin")) {
      $ahkArgs += 'M'        # Modern skin is the default
   } elseif ($pp["Skin"] -eq 1) {
      Write-Host 'You requested a modern skin in xplorer².'
      $ahkArgs += 'M'
   } else {
      Write-Host 'You requested NO modern skin in xplorer².'
   }
   if ($pp["Replace"] -eq 1) {
      Write-Host 'You requested to replace Explorer with xplorer².'
      $ahkArgs += 'R'
   } else {
      Write-Host 'xplorer² will NOT replace Windows Explorer.'
   }
   if ($pp["All"] -eq 1) {
      Write-Host 'You requested to replace Explorer with xplorer² for ALL users.'
      $ahkArgs += 'A'
   } else {
      Write-Host 'xplorer² will NOT replace Windows Explorer for other users.'
   }
   if (-not $pp.contains("Menu")) {
      $ahkArgs += 'C'        # xplorer² in folder context menus is the default
   } elseif ($pp["Menu"] -eq 1) {
      Write-Host 'You requested to include xplorer² in folder context menus.'
      $ahkArgs += 'C'
   } else {
      Write-Host 'You requested NOT include xplorer² in folder context menus.'
   }
   if ($pp.contains("Language")) {
      Write-Host ('You requested to set the xplorer² language to ' + $pp["Language"] + '.')
      $ahkArgs += ' ' + $pp["Language"]
   }
   if ($ahkArgs) {
      $SilentArgs = ''
      $ahkArgs = "$(Get-OSArchitectureWidth) $ahkArgs"
      # silent install with options requires AutoHotKey
      $ahkExe = 'AutoHotKey'
      $toolsDir    = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
      $ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
      $ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkFile`" $ahkArgs" -PassThru
      $ahkId = $ahkProc.Id
      Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
      Write-Debug "Process ID:`t$ahkId"
   } else {
      Write-Warning 'No valid package parameters were found. xplorer² will install with default options.'
      $SilentArgs = '/S'
   }
}

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   url            = 'https://zabkat.com/xplorer2_setup.exe'
   url64          = 'https://zabkat.com/xplorer2_setup64.exe'
   softwareName   = 'xplorer² Pro*'
   checksum       = '69857f605d31b63692a613b3f000665fe704e937999fed9af4d22f0fb95d670c'
   checksum64     = '27928019fb06bbefd629b4a0e7f4af3614f40fbbb3307da2dfdf05166f340296'
   checksumType   = 'sha256'
   silentArgs     = $SilentArgs
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

