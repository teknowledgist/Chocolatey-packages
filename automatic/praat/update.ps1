import-module evergreen
import-module chocolatey-au

function global:au_GetLatest {
   $Release = Get-LatestReleaseOnGitHub -URL 'https://github.com/praat/praat.github.io'

   $version = $Release.Tag.trim('v.').replace('_', '.')

   # processor levels: https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels
   $x86Build   = $Release.Assets | Where-Object { $_.DownloadURL -match 'intel32\.zip$'}
   $x64v1Build = $Release.Assets | Where-Object { $_.DownloadURL -match 'x64v1\.zip$' } # For old (pre-2014) processors
   $x64v3Build = $Release.Assets | Where-Object { $_.DownloadURL -match 'x64v3\.zip$' } # For modern processors
   $ARM64Build = $Release.Assets | Where-Object { $_.DownloadURL -match 'arm64\.zip$' } # For ARM processors
   

   return @{ 
            Version       = $version
            URL32         = $x86Build.DownloadURL
            Checksum32    = $x86Build.sha256
            URL64         = $x64v3Build.DownloadURL
            Checksum64    = $x64v3Build.sha256
            ARM64URL      = $ARM64Build.DownloadURL
            ChecksumARM64 = $ARM64Build.sha256
            x64v1URL      = $x64v1Build.DownloadURL
            Checksumx64v1 = $x64v1Build.sha256
           }
}

function global:au_SearchReplace {
    @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"        = "`${1} $($Latest.Version)"
         "(^- x86 URL\s+:).*"        = "`${1} $($Latest.URL32)"
         "(^- x86 Checksum\s+:).*"   = "`${1} $($Latest.Checksum32)"
         "(^- x64v3 URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^- x64v3 Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
      'tools\chocolateyinstall.ps1' = @{
         '^(\$ARM64URL\s*= ).*' = "`${1}'$($Latest.ARM64URL)'"
         '^(\$ARM64sha\s*= ).*' = "`${1}'$($Latest.ChecksumARM64)'"
         '^(\$x64v1URL\s*= ).*' = "`${1}'$($Latest.x64v1URL)'"
         '^(\$x64v1sha\s*= ).*' = "`${1}'$($Latest.Checksumx64v1)'"
      }
    }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Praat $($Latest.AppVersion) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
