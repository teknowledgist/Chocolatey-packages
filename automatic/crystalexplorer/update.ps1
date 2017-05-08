import-module au

$Start = 'http://crystalexplorer.scb.uwa.edu.au'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Start/downloads.html"

   $path = $download_page.Links | 
               Where-Object {$_.innertext -like "*.exe" } |
               Select-Object -ExpandProperty href -First 1

   $version = ($path -split '-')[1]
   $url = "$start/$path"

   return @{ Version = $version; URL = $url }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]version\s*=\s*)('.*')"  = "`$1'$($Latest.version)'"
        }
    }
}

update -ChecksumFor 32