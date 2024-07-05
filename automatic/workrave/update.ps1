import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/rcaelers/workrave'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.').replace('_','.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match '\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
            Version = $version
            URL32   = $URL
   }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
            "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
            "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
            "(^SHA256\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Workrave v$($Latest.Version) installer"
   Get-RemoteFiles -Purge -NoSuffix
}


update -ChecksumFor none -nocheckchocoversion
