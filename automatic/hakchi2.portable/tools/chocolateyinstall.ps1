$ErrorActionPreference = 'Stop'

$packageName= 'hakchi2.portable'
$version     = '2.17'
$url         = 'https://github.com/ClusterM/hakchi2/releases/download/2.17/hakchi2.zip'
$checkSum    = 'dcced7ff63861c534180756bd6de1b7b8a42c74af2897bd3d4bf9a8d9b35c3af'

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

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target -RunAsAdmin
