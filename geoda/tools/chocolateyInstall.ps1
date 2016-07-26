$version = '1.8.10'

$InstallArgs = @{
   packageName = 'geoda'
   installerType = 'exe'
   url = "http://la1.rcc.uchicago.edu/media/geoda_files/software/geoda/GeoDa-$version-Windows-32bit.exe"
   url64bit = "http://la1.rcc.uchicago.edu/media/geoda_files/software/geoda/GeoDa-$version-Windows-64bit.exe"
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

