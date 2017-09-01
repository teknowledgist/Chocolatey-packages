import-module au

$Release = 'https://github.com/clechasseur/pathcopycopy/releases/latest'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $urlstub = $download_page.links |? href -match '.exe$' | select -ExpandProperty href -First 1
   $url = "https://github.com$urlstub"

   $version = $urlstub.split('/') | ? {$_ -match '^[0-9.]+$'} | select -Last 1

   return @{ Version = $version; URL = $url }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^  url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^  Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

update -ChecksumFor 32