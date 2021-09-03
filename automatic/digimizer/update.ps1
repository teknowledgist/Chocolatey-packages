import-module au

function global:au_GetLatest {
   $MainPage = 'https://www.digimizer.com'
   $download_page = Invoke-WebRequest -Uri "$MainPage/download.php"

   $FooterString = $download_page.AllElements | Where-Object {$_.id -eq 'footer'} |Select-Object -ExpandProperty innertext
   $Version = $FooterString.split(' ') | Where-Object {($_ -match '\.') -and ($_ -match '[0-9.]+')}
   if ($Version.length -eq 1) { $Version = "$Version.0.0" }

   $urlstub = $download_page.links | Where-Object {$_.href -like '*.msi'} | Select-Object -ExpandProperty href -first 1
   $url = $MainPage + "/download/" + $urlstub

   return @{ Version = $version; URL = $url }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^   url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^   Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

update -ChecksumFor 32