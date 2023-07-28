import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/openrocket/openrocket'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $URL = $Release.Assets | Where-Object {$_.FileName -match '\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

   $version = $Release.Tag.trim('release-')

   return @{ 
      Version = $version
      URL32   = $URL
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
   Write-host "Downloading OpenRocket $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
