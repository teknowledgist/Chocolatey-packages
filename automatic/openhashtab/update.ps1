import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/namazso/OpenHashTab'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $Asset64 = $Release.Assets | 
               Where-Object {$_.FileName -match 'machine_x64\.msi$'} | 
               Select-Object -First 1
   $Asset32 = $Release.Assets | 
      Where-Object { $_.FileName -match 'machine_x86\.msi$' } | 
      Select-Object -First 1

   return @{ 
      Version    = $version
      URL32      = $Asset32.DownloadURL
      URL64      = $Asset64.DownloadURL
      Checksum32 = $Asset32.SHA256
      Checksum64 = $Asset64.SHA256
   }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^x86_URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^x86_SHA256\s+:).*" = "`${1} $($Latest.Checksum32)"
         "(^x64_URL\s+:).*"    = "`${1} $($Latest.URL64)"
         "(^x64_SHA256\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading OpenHashTab $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
