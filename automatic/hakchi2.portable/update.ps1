import-module au

$Release = 'https://github.com/ClusterM/hakchi2/releases/latest'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.links | ? {$_.href -match 'hakchi[0-9.]*[a-z]?.zip'} |select -ExpandProperty href
   $url = "https://github.com$urlstub"

   $versionstring = $download_page.links | 
                  ? {$_.OuterHTML -match 'internal version'} |
                  select -ExpandProperty OuterHTML
   $version = $versionstring -replace '.*version ([0-9.]+).*','$1'

   $InternalVersion = $version -replace '.* ([0-9.]+).*','$1'

   $VerifyText =  gc "tools\VERIFICATION.txt"
   $Current = ($VerifyText | ? {$_ -match '^Internal'}) -replace '.*: (.*)','$1'

   if ([version]$InternalVersion -gt [version]$Current) {
      Write-Host "Internal version has updated." -ForegroundColor Cyan
      $PackageVersion  = ($version -replace '.*?v([0-9.]+).*','$1') + '.0.' + (get-date -f 'yyyyMMdd')
      $AppVersion      = $version -replace '.*?v([0-9.]+.).*','$1'
   } else {
      Write-Host "No new internal version." -ForegroundColor Cyan
      $PackageVersion = ($VerifyText | ? {$_ -match '^Package'}) -replace '.*: (.*)','$1'
   }

   return @{ 
      Version    = $PackageVersion
      AppVersion = $AppVersion
      IntVersion = $InternalVersion
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
