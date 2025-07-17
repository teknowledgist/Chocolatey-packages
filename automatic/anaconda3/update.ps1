Import-module evergreen
import-module chocolatey-au

function global:au_GetLatest {
   $Meta = Get-EvergreenApp anaconda

   return @{ 
      Version    = $Meta.Version
      URL64      = $Meta.URI
      Checksum64 = $Meta.Sha256
      Options  = @{
         Headers = @{
            'authority' = 'repo.anaconda.com'
            'referer'   = 'https://repo.anaconda.com/archive/'
            'user-agent'= 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
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

Update-Package -ChecksumFor none
