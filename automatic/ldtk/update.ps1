import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/deepnight/ldtk'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match '\.exe$'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL32   = $URL
   }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version +:).*"          = "`${1} $($Latest.Version)"
            "(^- URL +:).*"              = "`${1} $($Latest.URL32)"
            "(^- SHA256 +:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading LDtk $($Latest.Version) installer"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
