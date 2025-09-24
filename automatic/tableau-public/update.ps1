import-module chocolatey-au

function global:au_GetLatest {
   $Version = Get-EvergreenApp TableauDesktop | Select-Object -ExpandProperty Version

   $URL64 = "https://downloads.tableau.com/public/TableauPublicDesktop-64bit-$($Version.replace('.','-')).exe"

   return @{ 
            Version  = $Version
            URL64    = $URL64
            Options  = @{
               # Headers pared down from https://github.com/aaronparker/evergreen/blob/main/Evergreen/Manifests/TableauDesktop.json
               Headers = @{
                  'dnt' = '1'
                  'authority' = 'www.tableau.com'
                  'sec-ch-ua' = '"Chromium";v="132", "Microsoft Edge";v="131", "Not-A.Brand";v="99"'
                  'accept-encoding' = 'gzip, deflate, br, zstd'
                  'priority' = 'u=0, i'
                  'path' = '/downloads/desktop/pc64'
                  'accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7'
               }
            }
           }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -ChecksumFor 64
