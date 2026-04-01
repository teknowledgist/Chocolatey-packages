import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/mulaRahul/keyviz'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $Asset = $Release.Assets | 
               Where-Object {$_.FileName -match '\.msi$'}

   return @{ 
      Version    = $Release.Tag.trim('v.')
      URL32      = $Asset.DownloadURL
      Checksum32 = $Asset.SHA256
   }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^SHA256\s+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading KeyViz $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
