$packageName = 'Olex2'

$InstallDir = Join-Path $env:ProgramData $packageName

$InstallArgs = @{
   PackageName = $packageName
   Url = 'http://www.olex2.org/olex2-distro/1.2/olex2-win32.zip'
   Url64 = 'http://www.olex2.org/olex2-distro/1.2/olex2-win64.zip'
   UnzipLocation = $InstallDir
   checkSum = '943B973452637C5D465B96EDB0109653527A39B356D720EC535C90F0EBC77E99'
   checkSum64 = 'A91F3C1677480F2AD805BB034D8B521CA87D6E69A873B5598DE1B7C032348B56'
   checkSumType = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs

$target   = Join-Path $InstallDir 'olex2.exe'
$DeskShortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Olex2-1.2.lnk'
$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Olex2-1.2.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $DeskShortcut -TargetPath $target
Install-ChocolateyShortcut -ShortcutFilePath $StartShortcut -TargetPath $target
