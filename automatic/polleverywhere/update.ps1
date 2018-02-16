import-module au


function global:au_GetLatest {
   $ReleasURL = 'https://www.polleverywhere.com/app/releases/win'

   $Release_page = Invoke-WebRequest -Uri $ReleasURL

   $url = $Release_page.links |
               Where-Object {$_.innertext -eq 'Download'} |
               Select-Object -First 1 -ExpandProperty href

   $version = $url -replace '.*/([0-9.]+)/.*$','$1'

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