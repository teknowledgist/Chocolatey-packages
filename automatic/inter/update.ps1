import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/rsms/inter'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $URL = $Release.Assets | Where-Object {$_.FileName -match '\.zip'} | Select-Object -First 1 -ExpandProperty DownloadURL

   if ($Release.Tag -match "beta") { 
      # Beta fonts are not worth the risk
      $version = '0.1'
   } else {
      $version = $Release.Tag.trim('v.')
   }

   return @{ 
      Version     = $version
      URL32       = $URL
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "^(- Version\s+:).*" = "`${1} $($Latest.Version)"
            "^(- URL\s+:).*"     = "`${1} $($Latest.URL32)"
            "^(- SHA256\s+:).*"  = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Inter font $($Latest.VersionText) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
