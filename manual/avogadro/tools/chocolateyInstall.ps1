$InstallArgs = @{
   packageName = 'avogadro'
   installerType = 'exe'
   url = 'https://sourceforge.net/projects/avogadro/files/avogadro/1.2.0/Avogadro-1.2.0n-win32.exe/download'
   checksum = 'BB15E67FC527C0D28DE32ABB2D0D0EE161829A64F3BF4887B8D786E3B0DAF270'
   checksumType = 'sha256'
   silentArgs = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
