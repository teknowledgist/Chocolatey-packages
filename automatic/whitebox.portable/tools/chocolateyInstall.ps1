$CheckSum = 'd530e48822cd03b3c3932329dbb92bb3322fecc34635dbb01ab6a9c8c0cf814d'
$url      = 'https://www.uoguelph.ca/~hydrogeo/Whitebox/WhiteboxGAT-win.zip' 

$InstallArgs = @{
   packageName   = 'whitebox.portable'
   url           = $url
   UnzipLocation = Split-path (Split-path $MyInvocation.MyCommand.Definition)
   CheckSum      = $CheckSum
   ChecksumType  = 'sha256'
}

Install-ChocolateyZipPackage @InstallArgs

$target = (Get-ChildItem $InstallArgs.UnzipLocation -filter whiteboxgis.jar -Recurse).fullname

$files = get-childitem (Split-Path $target ) -include *.exe -recurse
foreach ($file in $files) {
  #generate an ignore file
  New-Item "$file.ignore" -type file -force | Out-Null
}

$logs = Join-Path (Split-Path $target) 'logs'
if (-not (Test-Path $logs)) {
   New-Item $logs -ItemType Directory
}

# All users need modify rights to the logs directory or Whitebox won't start.  
# By default, only the installing user has modify rights.  This will give
# Authenticated users modify rights.
if (Test-Path $logs) {
   Remove-Item "$logs\*" -Recurse
   $Acl = Get-Acl $logs
   $InheritanceFlag = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
   # https://superuser.com/a/1176767/671995
   $sid = New-Object System.Security.Principal.SecurityIdentifier ([Security.Principal.WellKnownSidType]::AuthenticatedUserSid, $null)
   $rule = New-Object  system.security.accesscontrol.filesystemaccessrule($sid,'Modify',$InheritanceFlag,'none','Allow')
   $Acl.setaccessrule($rule)
   Set-Acl $logs $Acl
} else {
   throw 'Logs folder does not exist!'
}

# The program author offered an icon when contacted.
$icon = Join-Path $InstallArgs.UnzipLocation 'tools\TDAP_Home.ico'

$launcher = Join-Path $InstallArgs.UnzipLocation 'tools\WhiteBox Launcher.exe'
$JavaExe = "$env:ProgramData\Oracle\Java\javapath\javaw.exe"
$sg = Join-Path $env:ChocolateyInstall 'tools\shimgen.exe'

& $sg -o $launcher -p $JavaExe -c "-jar '$target'" -i $icon --gui

$shortcut = Join-Path ([Environment]::GetFolderPath('Desktop')) 'WhiteBoxGAT.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $launcher -IconLocation $icon
