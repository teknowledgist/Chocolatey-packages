import-module au

function global:au_GetLatest {
   $Release = 'https://github.com/otykier/TabularEditor/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri "$Release" -UseBasicParsing

   $urlstub = $download_page.rawcontent.split('"') | 
                Where-Object {$_ -match '\.msi$'} |
                Select-Object -First 1
   If ($urlstub -match '^https:') {
      $url = $urlstub
   } else {
      $url = "https://github.com$urlstub"
   }

   $null = $download_page.links |? {$_.href -match '/tag/([0-9.]+)'}
   $version = $Matches[1]

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Tabular Editor $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none

