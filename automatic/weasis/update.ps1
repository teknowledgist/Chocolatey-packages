import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/nroduit/Weasis'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL64 = $Release.Assets | Where-Object {$_.FileName -match '\.msi'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL64   = $URL64
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
            "(^Version\s+:).*"    = "`${1} $($Latest.Version)"
            "(^x64 URL\s+:).*"    = "`${1} $($Latest.URL64)"
            "(^x64 SHA256\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Weasis $($Latest.Version) installer files"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
