$InstallArgs = @{
   packageName = 'whitebox.portable'
   url = 'http://www.uoguelph.ca/~hydrogeo/Whitebox/WhiteboxGAT.zip' 
   UnzipLocation = Split-path (Split-path $MyInvocation.MyCommand.Definition)
}

Install-ChocolateyZipPackage @InstallArgs

$target = (Get-ChildItem $InstallArgs.UnzipLocation -filter whiteboxgis.jar -Recurse).fullname
$logs = Join-Path (Split-Path $target) "logs"

# All users need modify rights to the logs directory or Whitebox won't start.  
# By default, only the installing user has modify rights
if (-not (Test-Path $logs)) {
   New-Item $logs -ItemType Directory
}
if (Test-Path $logs) {
   Remove-Item "$logs\*" -Recurse
   $Acl = get-acl $logs
   $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
   $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::InheritOnly
   $rule = New-Object  system.security.accesscontrol.filesystemaccessrule('BUILTIN\Users','Modify',$InheritanceFlag,$PropagationFlag,'Allow')
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