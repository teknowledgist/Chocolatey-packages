import-module au

$Release = 'https://github.com/Lyndir/MasterPassword/releases'

function global:au_GetLatest {
   $ReleasesPage = Invoke-WebRequest -Uri $Release

   $version = ($ReleasesPage.links | 
                  Where-Object {$_.innertext -Match 'java'} | 
                  Select-Object -First 1 -ExpandProperty innertext).split("-")[0]

   $MainPage = Invoke-WebRequest -uri 'http://masterpasswordapp.com/'
   $url = $MainPage.links | 
               Where-Object {$_.innertext -Match 'java'} |
               Select-Object -First 1 -ExpandProperty href

   return @{ Version = $version; URL = $url }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]version\s*=\s*)('.*')" = "`$1'$($Latest.version)'"
        }
    }
}

update -ChecksumFor 32