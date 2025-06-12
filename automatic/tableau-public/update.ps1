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
                  'authority' = 'www.tableau.com'
                  'sec-ch-ua' = '"Chromium";v="132", "Microsoft Edge";v="131", "Not-A.Brand";v="99"'
                  'accept-encoding' = 'gzip, deflate, br, zstd'
                  'priority' = 'u=0, i'
                  'accept' = '*/*;q=0.8'
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
