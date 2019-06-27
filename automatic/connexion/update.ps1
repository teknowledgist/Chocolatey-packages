import-module au

$Release = 'https://www.oclc.org/support/software-reports/cataloging-software-downloads.en.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Release"

   $url = $download_page.links |
               Where-Object {($_.innertext -match 'connexion.*only') -and ($_.href -match '\.exe$')} | 
               Select-Object -ExpandProperty href
   
   if ($url -match '([0-9][0-9.]+)') {
      $version = $Matches[0].trim('.')
   }
   
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