import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/TheJoeFin/Text-Grab'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $Asset = $Release.Assets | Where-Object {$_.FileName -match '\.zip$'} | Select-Object -First 1 

   return @{ 
      Version = $version
      URL32   = $Asset.DownloadURL
      ZipFile = $Asset.FileName
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version:).*"     = "`${1} $($Latest.Version)"
            "(^- URL:).*"     = "`${1} $($Latest.URL32)"
            "(^- SHA256+:).*" = "`${1} $($Latest.Checksum32)"
      }
      'tools\chocolateyinstall.ps1' = @{
            '^(\$ZipFile = ).*' = "`${1}'$($Latest.ZipFile)'"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading RBTray $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
