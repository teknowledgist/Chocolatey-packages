import-module evergreen
import-module chocolatey-au

function global:au_GetLatest {
   $Release = Get-LatestReleaseOnGitHub -URL 'https://github.com/praat/praat.github.io'

   $version = $Release.Tag.trim('v.').replace('_', '.')

   $x86Build   = $Release.Assets | Where-Object { $_.DownloadURL -match 'intel32\.zip$'}
   $x64Build   = $Release.Assets | Where-Object { $_.DownloadURL -match 'intel64\.zip$' }
   $ARM64Build = $Release.Assets | Where-Object { $_.DownloadURL -match 'arm64\.zip$' }
   

   return @{ 
            Version       = $version
            URL32         = $x86Build.DownloadURL
            Checksum32    = $x86Build.sha256
            URL64         = $x64Build.DownloadURL
            Checksum64    = $x64Build.sha256
            ARM64URL      = $ARM64Build.DownloadURL
            ChecksumARM64 = $ARM64Build.sha256
           }
}

function global:au_SearchReplace {
    @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"        = "`${1} $($Latest.Version)"
         "(^- x86 URL\s+:).*"        = "`${1} $($Latest.URL32)"
         "(^- x86 Checksum\s+:).*"   = "`${1} $($Latest.Checksum32)"
         "(^- x64 URL\s+:).*"        = "`${1} $($Latest.URL64)"
         "(^- x64 Checksum\s+:).*"   = "`${1} $($Latest.Checksum64)"
      }
      'tools\chocolateyinstall.ps1' = @{
         '^(\s*URL64bit\s*= ).*'   = "`${1}'$($Latest.ARM64URL)'"
         '^(\s*Checksum64\s*= ).*' = "`${1}'$($Latest.ChecksumARM64)'"
      }
    }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Praat $($Latest.AppVersion) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
