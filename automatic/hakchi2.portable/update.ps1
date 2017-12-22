import-module au

$Release = 'https://github.com/ClusterM/hakchi2/releases/latest'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $urlstub = $download_page.links | ? {$_.href -match 'hakchi[0-9.]*[a-z]?.zip'} |select -ExpandProperty href
   $url = "https://github.com$urlstub"

   $version = $download_page.links | 
                  ? {$_.innertext -match 'internal version'} |
                  select -ExpandProperty innertext

   $version = $version -replace '.*?([0-9.]+)\)','$1'

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading hakchi $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
