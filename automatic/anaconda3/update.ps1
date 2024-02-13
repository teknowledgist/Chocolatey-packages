import-module au

function global:au_GetLatest {
   $Meta = Get-EvergreenApp anaconda

   return @{ 
      Version    = $Meta.Version
      URL64      = $Meta.URI
      Checksum64 = $Meta.Sha256
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
