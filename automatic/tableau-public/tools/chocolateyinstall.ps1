$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url64bit      = 'https://downloads.tableau.com/public/TableauPublicDesktop-64bit-2025-2-3.exe'
   checksum64    = ''
   checksumType  = 'sha256'
   silentArgs    = "/quiet /norestart /LOG `"$($env:TEMP)\TableauPublic-$($env:chocolateyPackageVersion)-InstallLogs\Install.log`" ACCEPTEULA=1"
   validExitCodes= @(0,3010)
   Options       = @{
         # Headers pared down from https://github.com/aaronparker/evergreen/blob/main/Evergreen/Manifests/TableauDesktop.json
         Headers = @{
                  'dnt' = '1'
                  'authority' = 'www.tableau.com'
                  'sec-ch-ua' = '"Chromium";v="132", "Microsoft Edge";v="131", "Not-A.Brand";v="99"'
                  'accept-encoding' = 'gzip, deflate, br, zstd'
                  'priority' = 'u=0, i'
                  'path' = '/downloads/desktop/pc64'
                  'accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7'
         }
      }
}

Install-ChocolateyPackage @packageArgs
