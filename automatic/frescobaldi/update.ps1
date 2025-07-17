import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/frescobaldi/frescobaldi'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL32 = $Release.Assets | Where-Object {$_.FileName -match '\.msi$'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL32   = $URL32
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyinstall.ps1" = @{
            "(^ +URL +=).*"      = "`${1} '$($Latest.URL32)'"
            "(^ +Checksum +=).*" = "`${1} '$($Latest.Checksum32)'"
      }
   }
}

Update-Package
