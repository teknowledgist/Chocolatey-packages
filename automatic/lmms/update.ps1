import-module au


function global:au_GetLatest {
   $Repo = 'https://github.com/LMMS/lmms'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL32 = $Release.Assets | Where-Object {$_.FileName -match 'win32\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL
   $URL64 = $Release.Assets | Where-Object {$_.FileName -match 'win64\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL32   = $URL32
      URL64   = $URL64
   }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
            "(^Version\s+:).*"    = "`${1} $($Latest.Version)"
            "(^URL\s+:).*"        = "`${1} $($Latest.URL32)"
            "(^Checksum\s+:).*"   = "`${1} $($Latest.Checksum32)"
            "(^URL64\s+:).*"      = "`${1} $($Latest.URL64)"
            "(^Checksum64\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading LMMS v$($Latest.Version) installer"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
