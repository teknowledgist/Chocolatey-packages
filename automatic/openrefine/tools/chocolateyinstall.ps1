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
   Url          = 'https://github.com/OpenRefine/OpenRefine/releases/download/3.4.1/openrefine-win-with-java-3.4.1.zip'
   Checksum     = 'a716c6ece7bc5edee5525ca943aaaae4b17ea4ff221a17d733da0bc4d45c43af'
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
