$ErrorActionPreference = 'Stop'  # stop on all errors

$PackageName = "chrlauncher.portable"
$version = '1.9.4'
$Url = "https://github.com/henrypp/chrlauncher/releases/download/v.$version/chrlauncher-$version-without-ppapi-bin.zip" 
$checkSum = '2AE995F2CC1E0ACE9B549C09CD78114BBBB2C087ABF0227BE842055843A4299D'

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
            $_.Groups[$value_name].Value.Trim())
    }
    }
    else
    {
        Throw 'Package Parameters were found but were invalid (REGEX Failure)'
    }
  
} else {
    Write-Debug 'No Package Parameters Passed in'
}

if ($UserArguments.ContainsKey('Flash')) {
   Write-Host 'You want the Flash Pepper Plugin API (PPAPI) included.'
   $URL = $Url.replace('-without-ppapi','')
   $checkSum = 'F901A439F60F49FEB4DF8D43D405B0C8C214C7FA7E959C2BF33FE26B09FFE5F4'
}

$PackageDir = Split-path (Split-path $MyInvocation.MyCommand.Definition)

$InstallArgs = @{
   PackageName = $PackageName
   Url = $URL 
   UnzipLocation = (Join-path $PackageDir ($PackageName.split('.')[0] + $version))
   checkSum = $checkSum
   checkSumType = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs

$BitLevel = Get-ProcessorBits

if ($UserArguments.ContainsKey('Default')) {
   Write-Host 'You want chrlauncher as your default browser.'
   $Bat = Join-Path $InstallArgs.unzipLocation "$BitLevel\SetDefaultBrowser.bat"
   $NoPauseBat = Join-Path (Split-Path $Bat) 'NoPauseSetDefaultBrowser.bat'
   (Get-Content $Bat) -ne 'pause' | Out-File $NoPauseBat -Encoding ascii -Force
   & $NoPauseBat
}

$target   = Join-Path $InstallArgs.UnzipLocation "$BitLevel\chrlauncher.exe"
$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Chromium Launcher.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target

