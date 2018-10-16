$InstallArgs = @{
   packageName = $env:ChocolateyPackageName
   installerType = 'exe'
   url = 'https://sourceforge.net/projects/openchrom/files//REL-1.3.0/openchrom_win32.win32.x86_64_1.3.0.zip'
   checksum = '0a84b9c0101c9db90c5672efa6de015d1a6a751d0b3822a92d3797a4df6994d3'
   checksumType = 'sha256'
   silentArgs = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
