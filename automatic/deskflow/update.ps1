import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/deskflow/deskflow'
#  $API = 'https://api.deskflow.org/version'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $Asset = $Release.Assets | Where-Object {$_.FileName -match 'x64\.msi$'} | Select-Object -First 1 
   $ARM64Asset = $Release.Assets | Where-Object { $_.FileName -match 'arm64\.msi$' } | Select-Object -First 1 

   return @{ 
      Version       = $version
      URL64         = $Asset.DownloadURL
      Checksum64    = $Asset.SHA256
      ZipFile       = $Asset.FileName
      ARM64URL      = $ARM64Asset.DownloadURL
      ARM64Checksum = $ARM64Asset.SHA256
      URL32         = $ARM64Asset.DownloadURL  # This is to trick AU's Get-Remote Files into downloading the ARM64 file
   }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version *:).*" = "`${1} $($Latest.Version)"
            "(^- X64 URL *:).*"   = "`${1} $($Latest.URL64)"
            "(^- X64 SHA256 Checksum *:).*"  = "`${1} $($Latest.Checksum64)"
            "(^- ARM64 URL *:).*"                = "`${1} $($Latest.ARM64URL)"
            "(^- ARM64 SHA256 Checksum *:).*"    = "`${1} $($Latest.ARM64Checksum)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Deskflow v$($Latest.Version) installers."
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
