$InstallArgs = @{
   packageName = 'openchrom'
   installerType = 'exe'
   url = 'https://sourceforge.net/projects/openchrom/files/REL-1.1.0/openchrom_1.1.0_x86_win-setup.exe/download'
   url64 = 'https://sourceforge.net/projects/openchrom/files/REL-1.1.0/openchrom_1.1.0_x86_64_win-setup.exe/download'
   checksum = '319E449D54BB568FDB68CD439326DE8332A7F95CFE7C4F8BFC97ED571213AB2B'
   checksum64 = '09CB8A71AC45CD1CECF93450F49CB880B994140F5061C8DC5398EE4B86610BC9'
   checksumType = 'sha256'
   silentArgs = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
