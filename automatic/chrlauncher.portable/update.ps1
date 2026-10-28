import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/henrypp/chrlauncher'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $Asset = $Release.Assets | Where-Object {$_.FileName -match '-bin\.7z'}

   return @{ 
            Version    = $version
            URL64      = $Asset.DownloadURL
            Checksum64 = $Asset.SHA256
           }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL64)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading ChrLauncher v$($Latest.Version) 7-zip file"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
