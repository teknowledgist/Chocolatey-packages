import-module au

$Release = 'https://github.com/ClusterM/hakchi2/releases/latest'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $urlstub = $download_page.links |? href -match 'hakchi2\.zip' | select -ExpandProperty href
   $url = "https://github.com$urlstub"

   $version = $urlstub -replace '.*download\/([1-9.]+)\/.*','$1'

   return @{ Version = $version; URL = $url }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]version\s*=\s*)('.*')"      = "`$1'$($Latest.Version)'"
        }
    }
}

update -ChecksumFor 32