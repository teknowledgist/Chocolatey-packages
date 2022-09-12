$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter 'openrefine*' | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.exe"
   Url          = 'https://oss.sonatype.org/service/local/artifact/maven/content?r=releases&g=org.openrefine&a=openrefine&v=3.6.1&c=win-with-java&p=zip'
   Checksum     = 'f57181a63d4dfea8f340a296e2000a66584cd855d2719db14d1416e1a8708b8c'
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}
$ZipFile = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = $ZipFile
   Destination  = $FolderOfPackage
}
Get-ChocolateyUnzip @UnzipArgs

$Target = get-childitem $FolderOfPackage -Filter openrefine.exe -recurse
$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcut = Join-Path $StartMenu 'OpenRefine.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $Target.FullName -RunAsAdmin

$files = get-childitem $FolderOfPackage -Filter *.exe -Exclude openrefine* -Recurse 
foreach ($file in $files) {
  #generate an ignore file
  $null = New-Item "$file.ignore" -type file -force
}
