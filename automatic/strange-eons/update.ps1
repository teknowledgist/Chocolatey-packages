import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/CGJennings/strange-eons/'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $URL64 = $Release.Assets | Where-Object {$_.FileName -match '\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

$version = $Release.Tag.trim('v.')

   return @{ 
      Version = $version
      URL64   = $URL64
   }
}


function global:au_SearchReplace {
   @{
       "legal\VERIFICATION.md" = @{
            "(^- Version:).*" = "`${1} $($Latest.Version)"
            "(^- URL:).*"     = "`${1} $($Latest.URL64)"
            "(^- SHA256:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

Update-Package -ChecksumFor none
