$ErrorActionPreference = 'Stop'

$ToolsDir   = Join-Path $env:ChocolateyPackageFolder 'tools'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter 'chrlauncher*' | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.zip").FullName
   Destination  = (Join-path $env:ChocolateyPackageFolder ($env:ChocolateyPackageName.split('.')[0] + $env:ChocolateyPackageVersion))
}

Get-ChocolateyUnzip @InstallArgs

$files = get-childitem $InstallArgs.Destination -include *.exe -recurse
foreach ($file in $files) {
   if ($file.name -eq 'hakchi.exe') {
      $target = $file.fullname
   } else {
      #generate an ignore file
      New-Item "$($file.fullname).ignore" -type file -force | Out-Null
   }
}
$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'hakchi2.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target -RunAsAdmin
