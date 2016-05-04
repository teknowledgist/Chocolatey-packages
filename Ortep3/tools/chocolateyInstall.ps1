$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName  = 'ortep3'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$DownloadUrl  = 'http://www.chem.gla.ac.uk/~louis/software/downloads/ortep_2014.1.zip'
 
$tempDir = Join-Path $env:TEMP $packageName
if (![System.IO.Directory]::Exists($tempDir)) {
   [System.IO.Directory]::CreateDirectory($tempDir)
}
 
$ZipPath = Join-Path $tempDir $DownloadURL.split('/')[-1]
 
# Download zip
Get-ChocolateyWebFile $packageName $ZipPath $DownloadURL
 
# Extract zip
Get-ChocolateyUnzip $ZipPath $tempDir

$InstallArgs = @{
   packageName   = $packageName
#  unzipLocation = $toolsDir
   fileType      = 'exe'
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes= @(0)
   url = (Join-Path $tempDir 'setup.exe')
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

if ($UserArguments.ContainsKey('InstallDir')) {
   Write-Host 'You requested a custom install directory.'
   $InstallDir = $UserArguments.InstallDir
} else {
   $InstallDir = Join-Path ${env:ProgramFiles(x86)} 'Ortep3'
}
$InstallArgs.silentArgs += ' /DIR="' + $InstallDir + '"'

# Execute installer
Install-ChocolateyPackage @InstallArgs

# Create necessary environment variable
Install-ChocolateyEnvironmentVariable 'ORTEP3DIR' $InstallDir 'Machine'

# Find/copy a license file
if ($UserArguments.ContainsKey('LicensePath')) {
   Write-Host 'You provided a license file path.'
   $LicensePath = $UserArguments.LicensePath
} else {
   $LicensePath = 'C:\Temp\ORTEP3-License.txt'
}
$LicenseArgs = @{
   packageName  = "Ortep3License"
   fileFullPath = (Join-Path $InstallDir 'ORTEP3-License.txt')
   url          = ([System.Uri]$LicensePath).AbsoluteUri
}
if (([System.Uri]$LicensePath).Scheme -eq 'file' -and 
    (-not (Test-Path ([System.Uri]$LicensePath).LocalPath))) {
      Write-host 'The license path does not exist.  You will need to manually copy a license file to the Ortep3 directory.'
} else {
   Get-ChocolateyWebFile @LicenseArgs
}

# Create an .ini file with default paths to helper applications
$iniString = @"
#
#  ORTEP.INI
#  System file for :
#  Ortep-3 for Windows Version 2014.1 (2014)
#
#
#  Locations of plugin executables
#
"@

if ($UserArguments.ContainsKey('editor')) {
   Write-Host 'You provided a TXT editor path.'
   $iniString += "`nEditorExecutable=" + $UserArguments['editor']
} else {
   $iniString += "`nEditorExecutable=c:\Windows\system32\notepad.exe"
}
if ($UserArguments.ContainsKey('povray')) {
   Write-Host 'You provided a POVray path.'
   $iniString += "`nPOVRayExecutable=" + $UserArguments['povray']
} else {
   $iniString += "`nPOVRayExecutable=C:\Program Files\POV-Ray\v3.7\bin\pvengine64.exe"
}
if ($UserArguments.ContainsKey('gsview')) {
   Write-Host 'You provided a GSView path.'
   $iniString += "`nPostScriptExecutable=" + $UserArguments['gsview']
} else {
   $iniString += "`nPostScriptExecutable=C:\Program Files\Ghostgum\gsview\gsview64.exe"
}
if ($UserArguments.ContainsKey('graphics')) {
   Write-Host 'You provided a Graphics path.'
   $iniString += "`nGraphicsExecutable=" + $UserArguments['graphics']
} else {
   $iniString += "`nGraphicsExecutable=c:\Program Files\irfanview\i_view32.exe"
}
if ($UserArguments.ContainsKey('hpgl')) {
   Write-Host 'You provided a HPGL path.'
   $iniString += "`nHPGLExecutable=" + $UserArguments['hpgl']
} else {
   $iniString += "`nHPGLExecutable=c:\Program Files\printgl\printglw.exe"
}

if (Test-Path (Join-Path $InstallDir 'ortep.ini')) {
   Throw 'Prior settings file found.  Will not overwrite helper program paths.'
} else {
   Write-Host 'Establishing helper applications paths.'
   $iniString -replace "`n","`r`n" > (Join-Path $InstallDir 'ortep.ini')
}
