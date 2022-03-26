$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName  = 'ortep3'
$toolsDir     = Split-Path -parent $MyInvocation.MyCommand.Definition
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

# Create a settings/license file home
$settingsPath = Join-Path $env:ProgramData 'Ortep3'
if (-not (test-path $settingsPath)) {
   New-Item $settingsPath -ItemType Directory
}
if (Test-Path $settingsPath) {
   Remove-Item "$settingsPath\*" -Recurse
   $Acl = get-acl $settingsPath
   $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
   $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::InheritOnly
   $rule = New-Object  system.security.accesscontrol.filesystemaccessrule('Authenticated Users','Modify',$InheritanceFlag,$PropagationFlag,'Allow')
   $Acl.setaccessrule($rule)
   set-acl $settingsPath $Acl

   # Create environment variable pointing to the license/ini file locations
   Install-ChocolateyEnvironmentVariable 'ORTEP3DIR' $settingsPath 'Machine'

   # Look for a license file
   if ($UserArguments.ContainsKey('LicensePath')) {
      Write-Host 'You provided a license file path.'
      $LicensePath = $UserArguments.LicensePath
   } else {
      $LicensePath = 'C:\Temp\ORTEP3-License.txt'
   }
   $LicenseArgs = @{
      packageName  = 'Ortep3License'
      fileFullPath = (Join-Path $settingsPath 'ORTEP3-License.txt')
      url          = ([System.Uri]$LicensePath).AbsoluteUri
   }
   if (([System.Uri]$LicensePath).Scheme -eq 'file' -and 
       (-not (Test-Path ([System.Uri]$LicensePath).LocalPath))) {
         $msg = "***No license found at $LicensePath.***`n" + 
               "***You will need to manually copy an 'ORTEP3-License.txt' file to the " + 
               "'$settingsPath' directory.***`n"
         Write-host $msg
   } else {
      Get-ChocolateyWebFile @LicenseArgs
   }

   # Create an .ini file with default paths to helper applications
   $iniPath = Join-Path $settingsPath 'ortep.ini'
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

   if (Test-Path $iniPath) {
      Write-Host 'Prior settings file found.  Will not overwrite helper program paths.'
   } else {
      Write-Host 'Establishing helper applications paths.'
      $iniString -replace "`n","`r`n" > $iniPath
   }

} else {
   throw 'Settings folder does not exist!'
}

# Execute installer
Install-ChocolateyPackage @InstallArgs
