import-module au

$Release = 'https://help.oclc.org/Librarian_Toolbox/Software_downloads/Download_cataloging_software?sl=en'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Release"

   $Link = $download_page.links |
               Where-Object {($_.innertext -match '\.exe')} |
               Select-Object -First 1

   $url = $Link.href
   $version = $link.title.trim('.exe') -replace '[^0-9.]',''

   return @{ 
      Version = $version
      URL32 = $url
   }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^\s*Url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^\s*Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

Update-Package