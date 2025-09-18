import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/TheJoeFin/Text-Grab'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $Asset = $Release.Assets | Where-Object {$_.FileName -match 'x64.*\.zip$'} | Select-Object -First 1 
   $ARM64Asset = $Release.Assets | Where-Object { $_.FileName -match 'arm64.*\.zip$' } | Select-Object -First 1 

   return @{ 
      Version       = $version
      URL64         = $Asset.DownloadURL
      Checksum64    = $Asset.SHA256
      ZipFile       = $Asset.FileName
      ARM64URL      = $ARM64Asset.DownloadURL
      ARM64Checksum = $ARM64Asset.SHA256
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version:).*" = "`${1} $($Latest.Version)"
            "(^- URL:).*"     = "`${1} $($Latest.URL64)"
            "(^- SHA256+:).*" = "`${1} $($Latest.Checksum64)"
      }
      'tools\chocolateyinstall.ps1' = @{
            '^(\$ZipFile = ).*' = "`${1}'$($Latest.ZipFile)'"
            '^(\s*URL64bit\s*= )' = "`${1}'$($Latest.ARM64URL)'"
            '^(\s*Checksum64\s*= )'    = "`${1}'$($Latest.ARM64Checksum)'"
      }
   }
}

update -ChecksumFor none
