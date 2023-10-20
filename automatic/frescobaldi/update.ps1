import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/frescobaldi/frescobaldi'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL32 = $Release.Assets | Where-Object {$_.FileName -match '\.exe$'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL32   = $URL32
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version:).*"     = "`${1} $($Latest.Version)"
            "(^- x86 URL:).*"     = "`${1} $($Latest.URL32)"
            "(^- x86 SHA256:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Frescobaldi $($Latest.Version) installer."
   Get-RemoteFiles -Purge -nosuffix
}

Update -ChecksumFor none
