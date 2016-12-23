$installArgs = @{
   packageName = 'jana2006'
   installerType = 'msi'
   url = 'http://www-xray.fzu.cz/jana/download/stable2006/janainst.msi'
   checkSum = '20DCA8F96855F1EB716418135B8B02D73936C992DA8CC0701B5D4010384036D4'
   checkSumType = 'sha256'
   silentArgs = '/qn'
   validExitCodes = @(0,3010)
}

Install-ChocolateyPackage @installArgs