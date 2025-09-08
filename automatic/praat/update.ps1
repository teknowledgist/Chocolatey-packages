import-module evergreen
import-module chocolatey-au

function global:au_GetLatest {
   Try {
      $Meta = Get-EvergreenApp praat | Where-Object {$_.architecture -eq 'x86'} -ErrorAction SilentlyContinue
      $x64 = $Meta | Where-Object {$_.uri -match '64\.zip$'}
      $version = $x64.Version
      $x64URL = $x64.URI
      $x86URL = ($Meta | Where-Object {$_.uri -match '32\.zip$'}).URI
   } 
   Catch {
      $Release = Get-LatestReleaseOnGitHub -URL 'https://github.com/praat/praat.github.io'

      $version = $Release.Tag.trim('v.').replace('_', '.')
      $Assets = $Release.Assets | Where-Object { $_.FileName -match '\.zip' } | Select-Object -First 2 -ExpandProperty DownloadURL
      $x86URL = $Assets | Where-Object { $_ -match '32\.zip$' }
      $x64URL = $Assets | Where-Object { $_ -match '64\.zip$' }
   }

   return @{ 
            Version    = $version
            URL32      = $x86URL
            URL64      = $x64URL
           }
}

function global:au_SearchReplace {
    @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^- x86 URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^- x86 Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
         "(^- x64 URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^- x64 Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
    }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Praat $($Latest.AppVersion) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
