import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/cthing/meazure'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match '\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL64   = $URL
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version\s*:).*" = "`${1} $($Latest.Version)"
            "(^- URL\s*:).*"     = "`${1} $($Latest.URL64)"
            "(^- SHA256\s*:).*"  = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Meazure $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
