Import-Module -Name Evergreen
Import-Module Chocolatey-AU

function global:au_GetLatest {
   $Meta = Get-EvergreenApp microsoftonedrive | 
            Where-Object {$_.ring -eq 'production' -and 
                           $_.architecture -eq 'x86' -and
                           $_.throttle -eq '100'
                         }

   return @{ 
      Version = $Meta.Version
      URL32   = $Meta.URI
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -nocheckchocoversion
