import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/OpenRefine/OpenRefine'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match 'with-java'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $Version
      URL32   = $URL
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   URL\s+=).*"      = "`${1} '$($Latest.URL32)'"
         "(^   Checksum\s+=).*" = "`${1} '$($Latest.Checksum32)'"
      }
   }
}

Update-Package

