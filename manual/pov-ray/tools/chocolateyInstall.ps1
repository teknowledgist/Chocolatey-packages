$packageName = 'POV-Ray'
$Version = '3.7'

# First download/install the _Application_ (one OSS license)
$InstallArgs = @{
   packageName = 'POV-Ray Application'
   installerType = 'exe'
   url = 'http://www.povray.org/redirect/www.povray.org/ftp/pub/povray/Official/povwin-3.7-agpl3-setup.exe'
   checkSum = '2B1331641B6F96113C2DBA951BE80D99EB548639480399CABB5E3A60DCE5BDC8'
   checkSumType = 'sha256'
   silentArgs = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs

# Then download/install the _Editor DLLs_ (a different OSS license)
$InstallArgs2 = @{
   packageName = "POV-Ray Editor"
   installerType = 'exe'
   url = 'http://www.povray.org/download/povwin-3.7-editor.exe'
   checkSum = '9265F0D3337F956AE42C1BC19B475182C3C5E543E96DF2287450AFB9738B6030'
   checkSumType = 'sha256'
   silentArgs = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs2

# Make POV-Ray appear in "Programs and Features" for all users.
Write-Debug 'Moving uninstall registry key from user to machine.'
$UserUninstall = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\POV-Ray for Windows v$Version"
$SystemUninstall = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\'
Copy-Item $UserUninstall $SystemUninstall -Recurse
Remove-Item $UserUninstall -Recurse

# Prevent POV-Ray from "inferring" its location for each user.
Write-Debug 'Setting POV-Ray "Home" for all users.'
$RegPath = "HKLM:\Software\POV-Ray\v$Version\Windows"
New-Item $RegPath -Force | Write-Debug
$RegValue = Join-Path $env:ProgramFiles "\POV-Ray\v$Version"
New-ItemProperty -Path $RegPath -Name 'Home' -Value $RegValue -force | Write-Debug

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

Write-Output "Copying libraries and settings..."
if ($UserArguments.ContainsKey('Default')) {
   Write-Output 'You requested to establish a default user profile.'
   # if installing as system, relative path to default doesn't work against $env:USERPROFILE
   $defaultProfile = Join-Path ([Environment]::GetFolderPath("commondesktopdirectory")) '..\..\default'
   copy-item (Join-Path $env:USERPROFILE "\Documents\POV-Ray") (join-path $defaultProfile "Documents") -recurse

   # Use Active Setup so all users will start POV-Ray with initialization settings
   #   See: http://www.itninja.com/blog/view/an-active-setup-primer
   $ActiveSetupKey = 'HKLM:\Software\Microsoft\Active Setup\Installed Components'
   New-Item -Path $ActiveSetupKey -Name $packageName -Value $packageName -Force | Write-Debug
   New-ItemProperty -Path (Join-Path $ActiveSetupKey $packageName) -Name "Version" -Value $Version -Force | Write-Debug
   # REG.EXE is often blocked, and WMIC is faster than loading PoSh at login.  
   #   For WMIC reference see: https://stackoverflow.com/questions/22265482/registry-edit-from-batch
   $WMICcmd = 'wmic.exe /NAMESPACE:\\root\default Class StdRegProv Call SetDWORDValue hDefKey="&H80000001" sSubKeyName="Software\POV-Ray\v3.7\Windows" sValueName="FreshInstall" uValue="1" > nul'
   New-ItemProperty -Path (Join-Path $ActiveSetupKey $packageName) -Name "StubPath" -Value $WMICcmd -Force | Write-Debug
} 
copy-item (Join-Path $env:USERPROFILE "\Documents\POV-Ray") (Join-Path $env:ProgramFiles "POV-Ray\v$Version\NewUserFiles") -recurse

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([Environment]::GetFolderPath("commondesktopdirectory")) "Launch $packageName v$Version.lnk"
   TargetPath = Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'Launch POV-Ray.bat'
   IconLocation = (Join-Path $env:ProgramFiles "POV-Ray\v$Version\bin\POV-Ray.ico")
}

Install-ChocolateyShortcut @ShortcutArgs
