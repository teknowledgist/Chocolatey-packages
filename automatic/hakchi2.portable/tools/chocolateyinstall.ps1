$ErrorActionPreference = 'Stop'

$packageName= 'hakchi2.portable'
$version     = '2.15'
$url         = 'https://github.com/ClusterM/hakchi2/releases/download/2.15/hakchi2.zip'
$checkSum    = '14c4a427e45a346dbe0932b83215739b6570e0ce7e9eed4f31ad7bea7dbdf59d'

$PackageDir = Split-path (Split-path $MyInvocation.MyCommand.Definition)

$InstallArgs = @{
   PackageName   = $PackageName
   Url           = $Url 
   UnzipLocation = (Join-path $PackageDir ($PackageName.split('.')[0] + '_' + $version))
   checkSum      = $checkSum
   checkSumType  = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs

$files = get-childitem $InstallArgs.UnzipLocation -include *.exe -recurse
foreach ($file in $files) {
   if ($file.name -eq 'hakchi.exe') {
      $target = $file.fullname
   } else {
      #generate an ignore file
      New-Item "$file.ignore" -type file -force | Out-Null
   }
}
$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'hakchi2.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target
