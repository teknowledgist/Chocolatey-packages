import-module au

$MainPage = 'http://www.digimizer.com'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$MainPage/download.php"

   $FooterString = $download_page.AllElements | ? {$_.id -eq 'footer'} |select -ExpandProperty innertext
   $Version = $FooterString.split() | ? { $_ -match '\d+\.\d+(\.\d+)+'}

   $urlstub = $download_page.links | ? {$_.href -like '*.msi'} | select -ExpandProperty href
   $url = $MainPage + $urlstub

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