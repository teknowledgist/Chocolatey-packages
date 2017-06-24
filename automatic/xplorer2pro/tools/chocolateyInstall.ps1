
$packageName = 'xplorer2pro'
$installerType = 'exe'
$url = 'http://zabkat.com/xplorer2_setup.exe'
$url64 = 'http://zabkat.com/xplorer2_setup64.exe'
$silentArgs = '/S'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
