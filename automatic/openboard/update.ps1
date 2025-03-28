import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/OpenBoard-org/OpenBoard'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   if ($version -match 'rc') {
      $version = '1.0'
   }
   $URL32 = $Release.Assets | Where-Object {$_.FileName -match '\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL32   = $URL32
   }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version\s*:).*" = "`${1} $($Latest.Version)"
            "(^- URL\s*:).*"     = "`${1} $($Latest.URL32)"
            "(^- Checksum\s*:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading OpenBoard $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
