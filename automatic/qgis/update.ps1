import-module au

$DownloadURI = 'https://www.qgis.org/en/site/forusers/download.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $null = $download_page.content.split("`n") |? {$_ -cmatch 'current version is QGIS ([0-9.]*)'}
   
   $version = $Matches[1]

   $url32 = $download_page.Links | ? {$_.href -match "$version.*x86\.exe`$"} | select -ExpandProperty href
   $url64 = $download_page.Links | ? {$_.href -match "$version.*64\.exe`$"} | select -ExpandProperty href

   return @{ 
            Version = $version
            URL32   = $url32
            URL64   = $url64
           }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
            "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

Update-Package