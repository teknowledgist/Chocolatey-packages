import-module au

$Release = 'https://github.com/White-Tiger/T-Clock/releases'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $urlstub = $download_page.links |? href -match '.7z$' | select -ExpandProperty href -First 1
   $url = "https://github.com$urlstub"

   $version = $urlstub -replace '.*download\/v([1-9.%]+).*','$1' -replace '%23','.'

   return @{ Version = $version; URL = $url }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^  url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^  Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]Version\s*=\s*)('.*')"      = "`$1'$($Latest.Version)'"
        }
    }
}

update -ChecksumFor 32