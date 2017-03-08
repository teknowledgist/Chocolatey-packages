$CheckSum = 'b1b1ab847ab2d91679ce50d2bcffa054ed6b763c5fede71dd575d22a9b2a87d2'
$url      = 'https://www.uoguelph.ca/~hydrogeo/Whitebox/WhiteboxGAT.zip' 

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
