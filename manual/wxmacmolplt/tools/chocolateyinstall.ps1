$packageName = 'wxMacMolPlt'
$version = '7.7'

$InstallDir = Split-path (Split-path $MyInvocation.MyCommand.Definition)

$InstallArgs = @{
   PackageName = $packageName
   Url = 'https://uofi.box.com/shared/static/r0jifp0tg0gjc5y51rl9i1dumq3q46nm.zip' 
   Url64 = 'https://uofi.box.com/shared/static/ah3hq3omjz45jm882n5ye8tzg7tq7i6r.zip'
   UnzipLocation = $InstallDir
   checkSum = '391E412CB5AF06E02EF63BD960632D93DDDD5526B68C8A7C0694544FD1DE9757'
   checkSum64 = '2396D0075A229422D9565F1093BFB6B6B84D4098CD83E544E262E4386F21F5B2'
   checkSumType = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs


$target   = (gci $InstallDir 'wxMacMolPlt.exe' -Recurse).FullName
$shortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\programs\$packageName.lnk"

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target
