$CheckSum = 'D530E48822CD03B3C3932329DBB92BB3322FECC34635DBB01AB6A9C8C0CF814D'
$url      = 'https://www.uoguelph.ca/~hydrogeo/Whitebox/WhiteboxGAT-win.zip' 

$InstallArgs = @{
   packageName   = 'whitebox.portable'
   url           = $url
   UnzipLocation = Split-path (Split-path $MyInvocation.MyCommand.Definition)
   CheckSum      = $CheckSum
}

Install-ChocolateyZipPackage @InstallArgs

$target = (Get-ChildItem $InstallArgs.UnzipLocation -filter whiteboxgis.jar -Recurse).fullname

$files = get-childitem (Split-Path $target ) -include *.exe -recurse
foreach ($file in $files) {
  #generate an ignore file
  New-Item "$file.ignore" -type file -force | Out-Null
}

# All users need modify rights to the logs directory or Whitebox won't start.  
# By default, only the installing user has modify rights
$logs = Join-Path (Split-Path $target) "logs"
if (-not (Test-Path $logs)) {
   New-Item $logs -ItemType Directory
}
if (Test-Path $logs) {
   Remove-Item "$logs\*" -Recurse
   $Acl = get-acl $logs
   $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
   $rule = New-Object  system.security.accesscontrol.filesystemaccessrule('BUILTIN\Users','Modify',$InheritanceFlag,'none','Allow')
   $Acl.setaccessrule($rule)
   set-acl $logs $Acl
} else {
   throw "Logs folder does not exist!"
}

# The program author offered an icon when contacted.
$icon = Join-Path $InstallArgs.UnzipLocation 'tools\TDAP_Home.ico'

$launcher = Join-Path $InstallArgs.UnzipLocation 'tools\WhiteBox Launcher.exe'
$JavaExe = 'C:\ProgramData\Oracle\Java\javapath\javaw.exe'
$sg = Join-Path $env:ChocolateyInstall 'tools\shimgen.exe'

& $sg -o $launcher -p $JavaExe -c "-jar '$target'" -i $icon --gui

$shortcut = Join-Path ([Environment]::GetFolderPath('Desktop')) 'WhiteBoxGAT.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $launcher -IconLocation $icon
