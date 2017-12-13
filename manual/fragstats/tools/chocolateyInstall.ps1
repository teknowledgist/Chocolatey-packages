$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.zip').FullName

$UnzipArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = $fileLocation
   Destination  = Join-Path $env:TEMP "$env:ChocolateyPackageName\unzipped"
}

Get-ChocolateyUnzip @UnzipArgs


$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   file           = (Get-ChildItem $UnzipArgs.Destination -Filter '*.exe' -Recurse).FullName
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}
  
Install-ChocolateyPackage @InstallArgs

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
   else { 
      Write-Warning 'Package Parameters were found but were invalid (REGEX Failure)' 
   }
} else {
   Write-Debug 'No Package Parameters Passed in'
}

if ($UserArguments.ContainsKey('DLL')) {
   Write-Host 'You requested to add a path to the "aigridio.dll" library.'
   Install-ChocolateyPath $UserArguments.DLL 'Machine'
}
