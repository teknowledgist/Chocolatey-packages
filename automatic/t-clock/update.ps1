import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/White-Tiger/T-Clock'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.').replace('#','.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match '\.7z'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      'tools\VERIFICATION.txt' = @{
         '(^Version\s+:).*'      = "`${1} $($Latest.Version)"
         '(^URL\s+:).*'          = "`${1} $($Latest.URL32)"
         '(^Checksum\s+:).*'     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading T-Clock $($Latest.Version) zip file."
   Get-RemoteFiles -Purge -NoSuffix -FileNameBase 'T-Clock'
}

update -ChecksumFor none
