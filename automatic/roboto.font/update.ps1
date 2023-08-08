import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/googlefonts/roboto-classic'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $URL = $Release.Assets | Where-Object {$_.FileName -match '\.zip'} | Select-Object -First 1 -ExpandProperty DownloadURL

   if ($URL) { 
      $version = $Release.Tag.trim('v.')
   } else {
      $version = '0.1'
      $URL = $Release.ZipballURL
   }

   return @{ 
      Version     = $version
      VersionText = $version   # Chocolatey versions strip leading 0's
      URL32       = $URL
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "^(- Version\s+:).*" = "`${1} $($Latest.Version)"
            "^(- URL\s+:).*"     = "`${1} $($Latest.URL32)"
            "^(- SHA256\s+:).*"  = "`${1} $($Latest.Checksum32)"
      }
      "tools\chocolateyinstall.ps1" = @{
            "^([$]RepoVersion =).*" = "`${1} '$($Latest.VersionText)'"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Roboto font $($Latest.VersionText) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
