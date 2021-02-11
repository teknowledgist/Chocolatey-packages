import-module au

function global:au_GetLatest {
   $BaseURL = 'https://www.cgl.ucsf.edu'

   $download_page = Invoke-WebRequest -Uri "$BaseURL/chimera/download.html"

   $HREF = $download_page.links | 
                  Where-Object {$_.href -match '([0-9.]+)-win64.exe'} | 
                  Select-Object -ExpandProperty href

   $version = $Matches[1]

   $body = 'choice=Accept&' + $HREF.split('?')[-1]
   $URI = $BaseURL + ($HREF.split('?')[0])
   $result = Invoke-WebRequest $URI -body $body -Method Post

   $url64 = $BaseURL + ($result.links |Select-Object -ExpandProperty href)

   return @{ 
      Version = $version
      URL64 = $url64 
   }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^`$AppVersion = )('.*')"      = "`$1'$($Latest.Version)'"
            "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

update -ChecksumFor 64