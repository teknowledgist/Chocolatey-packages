$InstallArgs = @{
   packageName = 'tinn-r'
   installerType = 'exe'
   url = "http://nbcgib.uesc.br/lec/download/software/Tinn-R_04.00.03.05_setup.exe"
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR="C:\Program Files\Tinn-R"'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
