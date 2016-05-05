$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName  = 'WinGX'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$DownloadUrl  = 'http://www.chem.gla.ac.uk/~louis/software/downloads/wingx_2014.1.zip'
 
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
   $InstallDir = Join-Path ${env:ProgramFiles(x86)} 'WinGX'
}
$InstallArgs.silentArgs += ' /DIR="' + $InstallDir + '"'

# Execute installer
Install-ChocolateyPackage @InstallArgs

# The settings .ini file needs to be writable by users and also must be 
# in the same location as the license file.  
$wgxdir = New-Item (Join-Path $env:ProgramData 'WinGX') -ItemType Directory
if (Test-Path $wgxdir.FullName) {
   $Acl = get-acl $wgxdir.FullName
   $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
   $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::InheritOnly
   $rule = New-Object  system.security.accesscontrol.filesystemaccessrule('Authenticated Users','Modify',$InheritanceFlag,$PropagationFlag,'Allow')
   $Acl.setaccessrule($rule)
   set-acl $wgxdir.FullName $Acl
} 

# Find/copy a license file
if ($UserArguments.ContainsKey('LicensePath')) {
   Write-Host 'You provided a license file path.'
   $LicensePath = $UserArguments.LicensePath
} else {
   $LicensePath = 'C:\Temp\WinGX-License.txt'
}
$LicenseArgs = @{
   packageName  = 'WinGXLicense'
   fileFullPath = (Join-Path $wgxdir.FullName 'WinGX-License.txt')
   url          = ([System.Uri]$LicensePath).AbsoluteUri
}
if (([System.Uri]$LicensePath).Scheme -eq 'file' -and 
    (-not (Test-Path ([System.Uri]$LicensePath).LocalPath))) {
      Write-host "The license path does not exist.  You will need to manually copy a license file to the $env:ProgramData\WinGX directory or paste the license text when prompted on the first start of WinGX."
} else {
   Get-ChocolateyWebFile @LicenseArgs
}

# Create necessary environment variables
Install-ChocolateyEnvironmentVariable 'WINGXDIR' (Join-Path $env:ProgramData 'WinGX') 'Machine'
Install-ChocolateyEnvironmentVariable 'PGFONT' (Join-Path $InstallDir 'Files\grfont.dat') 'Machine'

