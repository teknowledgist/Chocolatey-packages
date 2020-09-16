import-module au

$Release = 'https://github.com/ClusterM/hakchi2/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match 'hakchi[0-9.]*[a-z]?\.zip"'} |
                Select-Object -First 1
   $url = "https://github.com" + $($urlstub -replace '.*?"([^ ]+\.zip).*','$1')

   $versionstring = $download_page.rawcontent.split("<>") | 
                      Where-Object {$_ -match 'internal version'} |
                      Select-Object -First 1
   $NewInternalVersion = [version]($versionstring -replace '.*version ([0-9.]+).*','$1')
   $NewAppVersion = ($versionstring -replace '.*v([0-9.]+).*','$1')

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

update -ChecksumFor none -force
