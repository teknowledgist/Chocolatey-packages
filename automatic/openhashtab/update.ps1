import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/namazso/OpenHashTab'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL = $Release.Assets | 
               Where-Object {$_.FileName -match '\.exe$'} | 
               Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ Version = $version; URL32 = $url }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^SHA256\s+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading OpenHashTab $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
