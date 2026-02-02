import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/edrlab/thorium-reader'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   if ($version -match '^[0-9.]+$') {
      $Asset = $Release.Assets | Where-Object { $_.FileName -match "setup\.$version\.exe$" } | Select-Object -First 1 
      $ARM64Asset = $Release.Assets | Where-Object { $_.FileName -match 'arm64\.exe$' } | Select-Object -First 1 
   } else {
      Return @{ $version = '1.0.0' }
   }

   return @{ 
      Version       = $version
      URL32         = $Asset.DownloadURL
      Checksum32    = $Asset.SHA256
      ARM64URL      = $ARM64Asset.DownloadURL
      ARM64Checksum = $ARM64Asset.SHA256
   }
}

function global:au_SearchReplace {
   @{
      'tools\chocolateyinstall.ps1' = @{
         "^([$]x86URL\s*=).*"        = "`${1} '$($Latest.URL32)'"
         "^([$]x86Checksum\s*=).*"   = "`${1} '$($Latest.Checksum32)'"
         "^([$]ARM64URL\s*=).*"      = "`${1} '$($Latest.ARM64URL)'"
         "^([$]ARM64Checksum\s*=).*" = "`${1} '$($Latest.ARM64Checksum)'"
      }
   }
}

update -ChecksumFor none

