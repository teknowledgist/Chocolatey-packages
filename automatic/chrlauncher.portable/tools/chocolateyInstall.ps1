$ErrorActionPreference = 'Stop'  # stop on all errors

$PackageName = 'chrlauncher.portable'
$version     = '2.3'
$url         = 'https://github.com//henrypp/chrlauncher/releases/download/v.2.3/chrlauncher-2.3-bin.zip'
$checkSum    = '4b5acc8133e90cab735559e652dea5f6996f0c4781d4ccf65bd517e2561734d0'

$PackageDir = Split-path (Split-path $MyInvocation.MyCommand.Definition)

$InstallArgs = @{
   PackageName   = $PackageName
   Url           = $Url 
   UnzipLocation = (Join-path $PackageDir ($PackageName.split('.')[0] + $version))
   checkSum      = $checkSum
   checkSumType  = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs

$BitLevel = Get-ProcessorBits
$target   = Join-Path $InstallArgs.UnzipLocation "$BitLevel\chrlauncher.exe"
$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Chromium Launcher.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target


# Capturing Package Parameters.
$UserArguments = @{}
if ($env:chocolateyPackageParameters) {
   $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
   $option_name = 'option'
   $value_name = 'value'

   if ($env:chocolateyPackageParameters -match $match_pattern ){
      $results = $env:chocolateyPackageParameters | Select-String $match_pattern -AllMatches
      $results.matches | ForEach-Object {$UserArguments.Add(
                           $_.Groups[$option_name].Value.Trim(),
                           $_.Groups[$value_name].Value.Trim())
                        }
   } else { Throw 'Package Parameters were found but were invalid (REGEX Failure)' }
} else { Write-Debug 'No Package Parameters Passed in' }

if ($UserArguments.ContainsKey('Default')) {
   $msgtext = 'You want chrlauncher as the system default browser.'
   Write-Host $msgtext -ForegroundColor Cyan
   $Bat = Join-Path $InstallArgs.unzipLocation "$BitLevel\SetDefaultBrowser.bat"
   $NoPauseBat = Join-Path (Split-Path $Bat) 'NoPauseSetDefaultBrowser.bat'
   (Get-Content $Bat) -ne 'pause' | Out-File $NoPauseBat -Encoding ascii -Force
   & $NoPauseBat
}

if ($UserArguments.ContainsKey('Shared')) {
   $msgtext = 'You want chrlauncher to install/update/launch a single instance of Chromium to be shared (including settings, bookmarks, etc.) among all users.'
   Write-Host $msgtext -ForegroundColor Cyan
   $Acl = get-acl $InstallArgs.UnzipLocation
   $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
   $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::InheritOnly
   $rule = New-Object  system.security.accesscontrol.filesystemaccessrule('BUILTIN\Users','Modify',$InheritanceFlag,$PropagationFlag,'Allow')
   $Acl.setaccessrule($rule)
   set-acl $InstallArgs.UnzipLocation $Acl
} else {
   $msgtext = 'chrlauncher will install/update/launch Chromium independently for each user.'
   Write-Host $msgtext -ForegroundColor Cyan
   $INIfile = Join-Path (Split-Path $target) 'chrlauncher.ini'
   (gc $INIfile) -replace "^(ChromiumDirectory=).*$",'$1%appdata%\Chromium\bin' | Set-Content $INIfile
}

