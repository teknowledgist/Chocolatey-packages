$ErrorActionPreference = 'Stop'

$packageName = 'tinn-r'
$URL         = 'https://sourceforge.net/projects/tinn-r/files/latest/download?source=files'
$Checksum    = '148a63769f9b794a5df5938253d8da763e4525accb35e1229599ed3165395550'


$InstallArgs = @{
   packageName    = $packageName
   installerType  = 'exe'
   url            = $url
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR="C:\Program Files\Tinn-R" /NOICONS=0'
   Checksum       = $Checksum
   ChecksumType   = 'sha256'
   validExitCodes = @(0)
}

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

if ($UserArguments.ContainsKey('Default')) {
   Write-Host 'You requested that the default file-types open in Tinn-R.'
} else {
   $InstallArgs.silentArgs += ' /Tasks='
}

Install-ChocolateyPackage @InstallArgs
