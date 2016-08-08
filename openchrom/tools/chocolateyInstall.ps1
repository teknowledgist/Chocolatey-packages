$InstallArgs = @{
   packageName = 'openchrom'
   installerType = 'exe'
   url = 'https://sourceforge.net/projects/openchrom/files/REL-1.1.0/openchrom_1.1.0_x86_win-setup.exe/download'
   url64 = 'https://sourceforge.net/projects/openchrom/files/REL-1.1.0/openchrom_1.1.0_x86_64_win-setup.exe/download'
   checksum = 'a4c4b31da596a8eec24832042eacfb06b357d1dd'
   checksum64 = '1c564bcb1ce1c39f89c124d1aeaeb3410357cfbf'
   checksumType = 'sha1'
   silentArgs = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
