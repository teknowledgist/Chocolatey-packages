$InstallArgs = @{
   packageName    = 'GSView'
   url            = 'http://www.artifex.com/gsview/download/gsview_setup_6.0.exe'
   checksum       = 'A69309F58330391A4EDF5C343DB293FFC6EA47699A012FE233142984E0357DD8'
   checksumType   = 'sha256'
   fileType       = 'exe'
   silentArgs     = "/S"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

