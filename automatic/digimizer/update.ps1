import-module au

$MainPage = 'https://www.digimizer.com'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$MainPage/download.php"

   $FooterString = $download_page.AllElements | ? {$_.id -eq 'footer'} |select -ExpandProperty innertext
   $Version = $FooterString.split(';-') | ? { $_ -match 'version'}
   $Version = $Version -replace '[^0-9]*([0-9.]*).*','$1'
   if ($Version.length -eq 1) { $Version = "$Version.0.0" }

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