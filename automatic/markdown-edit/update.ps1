import-module au

$Release = 'https://github.com/mike-ward/Markdown-Edit/releases/latest/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $urlstub = $download_page.links |? href -match '\.msi' | select -ExpandProperty href
   $url = "https://github.com$urlstub"

   $version = ($download_page.links |? href -match '\/tag\/v').href -replace '.*\/tag\/v(.+)','$1'

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