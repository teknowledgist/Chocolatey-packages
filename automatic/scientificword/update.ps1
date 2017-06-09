import-module au

$Release = 'https://www.mackichan.com/products/dnloadreq.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $url = $download_page.Links | 
            Where-Object {$_.innertext -match 'Scientific Word . for Windows'} | 
            select -ExpandProperty href

   $version = ((Split-Path $url -Leaf) -split '-')[1]

   return @{ Version = $version; URL = $url }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

update -ChecksumFor 32