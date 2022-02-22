import-module au


function global:au_GetLatest {
   $Release = 'https://github.com/TeamShinkansen/Hakchi2-CE/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match '\.exe"'} |
                Select-Object -First 1
   $url = "https://github.com" + $($urlstub -replace '.*?"([^ ]+\.exe).*','$1')

   $version = ($url.split('/') | ? {$_ -match '^v?([0-9.]+)$'}).trim('v')

   return @{ 
      Version    = $version
      URL32      = $url
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^SHA256\s+:).*"       = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Hakchi CE $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
