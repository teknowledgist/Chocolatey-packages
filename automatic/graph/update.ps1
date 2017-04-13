import-module au

$Site = 'https://www.padowan.dk'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Site/download/"

   $urlstub = $download_page.links |? href -match '\.exe' | select -ExpandProperty href
   $url = $Site + $urlstub

   $version = $urlstub -replace '.*-([1-9.]+)\.exe.*','$1'

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