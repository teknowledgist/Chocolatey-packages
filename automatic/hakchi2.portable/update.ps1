import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/ClusterM/hakchi2'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match 'hakchi[0-9.]*[a-z]?\.zip'} | Select-Object -First 1 -ExpandProperty DownloadURL

   $NewInternalVersion = [version]($Release.Name -replace '.*version ([0-9.]+).*','$1')
   $NewAppVersion = $Release.Tag.trim('v.')

   $VerifyText =  Get-Content "tools\VERIFICATION.txt"
   $CurrentInternalVersion = [version](($VerifyText | Where-Object {$_ -match '^Internal'}) -replace '.*: (.*)','$1')

   if ($NewInternalVersion -gt $CurrentInternalVersion) {
      Write-Host "Internal version has updated." -ForegroundColor Cyan
      $PackageVersion  = $NewAppVersion + '.0.' + (get-date -f 'yyyyMMdd')
   } else {
      Write-Host "No new internal version." -ForegroundColor Cyan
      $PackageVersion = ($VerifyText | Where-Object {$_ -match '^Package'}) -replace '.*: (.*)','$1'
   }

   return @{ 
      Version    = $PackageVersion
      AppVersion = $NewAppVersion
      IntVersion = $NewInternalVersion
      URL32      = $url
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Package Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^App Version\s+:).*"      = "`${1} $($Latest.AppVersion)"
         "(^Internal Version\s+:).*" = "`${1} $($Latest.IntVersion)"
         "(^URL\s+:).*"              = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"         = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading hakchi $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
