$ErrorActionPreference = 'Stop'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter 'openrefine*' | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.exe"
   Url          = 'https://github.com/OpenRefine/OpenRefine/releases/download/3.5.2/openrefine-win-with-java-3.5.2.zip'
   Checksum     = 'd287ffcafb1a939a1c0bb8943064bff9722f2a3d7e786f818b61c9b362bf6c25'
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}
$ZipFile = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = $ZipFile
   Destination  = $env:ChocolateyPackageFolder
}
Get-ChocolateyUnzip @UnzipArgs

$Target = get-childitem $env:ChocolateyPackageFolder -Filter openrefine.exe -recurse
$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcut = Join-Path $StartMenu 'OpenRefine.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $Target.FullName -RunAsAdmin

$files = get-childitem $env:ChocolateyPackageFolder -Filter *.exe -Exclude openrefine* -Recurse 
foreach ($file in $files) {
  #generate an ignore file
  $null = New-Item "$file.ignore" -type file -force
}
