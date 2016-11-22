$InstallArgs = @{
   packageName = 'tinn-r'
   installerType = 'exe'
   url = 'https://sourceforge.net/projects/tinn-r/files/Tinn-R%20setup/5.1.2.0/Tinn-R_5.01.02.00_setup.exe/download'
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR="C:\Program Files\Tinn-R" /NOICONS=0'
   Checksum = '148A63769F9B794A5DF5938253D8DA763E4525ACCB35E1229599ED3165395550'
   ChecksumType = 'sha256'
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
