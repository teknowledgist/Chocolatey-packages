$InstallArgs = @{
   packageName = 'graph'
   installerType = 'exe'
   url = "https://www.padowan.dk/bin/SetupGraph-4.4.2.exe"
   Checksum = 'c95cfd8a22189cd5aeaa6a6fdb9ae9e3f846598c'
   ChecksumType = 'sha1'
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

