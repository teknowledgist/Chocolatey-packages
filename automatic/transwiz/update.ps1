import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://www.forensit.com/downloads.html'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $main = $download_page.links |
                  where-object {$_.innertext -match 'transwiz'} | 
                  select -ExpandProperty innertext -First 1
   $version = $main.split()[-1]

   return @{ 
      Version = $version
      URL = 'https://www.forensit.com/Downloads/Transwiz.msi'
   }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^\s*Url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^\s*Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

update