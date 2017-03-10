import-module au

$Release = 'https://geodacenter.github.io/download_windows.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $regex = '^.*?/(.*?\.zip).*'
   $urls = $download_page.links | ? {$_.href -match 'geoda-.*\.exe'} | select -ExpandProperty href -First 2
   $url64 = $urls[0]
   $url32 = $urls[1]

   $version = (($urls[0] -split '/')[-1] -split '-')[1]

   return @{ 
            Version = $version
            URL32 = $url32
            URL64 = $url64
           }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]Checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

Update-Package