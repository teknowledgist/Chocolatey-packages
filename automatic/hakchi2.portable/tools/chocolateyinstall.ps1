$ErrorActionPreference = 'Stop'

$packageName= 'hakchi2.portable'
$version     = '2.16'
$url         = 'https://github.com/ClusterM/hakchi2/releases/download/2.16/hakchi2.zip'
$checkSum    = '8a55ff053849722a0c8a6fbc71a6cb38b57d7da0db6a55335df19aa24c529a05'

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
