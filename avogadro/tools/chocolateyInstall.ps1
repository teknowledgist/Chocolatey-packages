$InstallArgs = @{
   packageName = 'avogadro'
   installerType = 'exe'
   url = 'https://sourceforge.net/projects/avogadro/files/avogadro/1.2.0/Avogadro-1.2.0n-win32.exe/download'
   checksum = '9b23bb56695a92ab4ee9a0ae87702cb4dcfe44f3'
   checksumType = 'sha1'
   silentArgs = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
