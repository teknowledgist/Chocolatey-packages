import-module au

function global:au_GetLatest {
   $Release = 'https://github.com/cthing/meazure/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $URLstub = $download_page.links | Where-Object {$_.href -match '\.exe'} | 
               Select-Object -ExpandProperty href -First 1

   $version = ($URLstub.split('/') | Where-Object {$_ -match '^v?[0-9.]+$'}).trim("v.")

   return @{ 
      Version = $version
      URL64   = "https://github.com$URLstub"
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version\s*:).*" = "`${1} $($Latest.Version)"
            "(^- URL\s*:).*"     = "`${1} $($Latest.URL64)"
            "(^- SHA256\s*:).*"  = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Meazure $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
