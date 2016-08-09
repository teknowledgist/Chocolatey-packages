$installArgs = @(
   packageName = 'jana2006'
   installerType = 'msi'
   url = 'http://www-xray.fzu.cz/jana/download/stable2006/janainst.msi'
   hash = 'AB13A4AF1964AC94EAE1AC2FBD03791DEB06F752'
   hashType = 'sha1'
   silentArgs = '/quiet'
   validExitCodes = @(0,3010)
)

Install-ChocolateyPackage @installArgs