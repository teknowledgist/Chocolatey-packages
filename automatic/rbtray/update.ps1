import-module au

function global:au_GetLatest {
   $Release = 'https://github.com/benbuck/rbtray/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $URLs = $download_page.links | Where-Object {$_.href -match '\.zip'} | 
               Select-Object -ExpandProperty href -First 2

   $URLstub32 = $urls | Where-Object {$_ -match 'x86\.zip$'}
   $URLstub64 = $urls | Where-Object {$_ -match 'x64\.zip$'}

   $version = ($URLstub64.split('/') | Where-Object {$_ -match '^v?[0-9.]+$'}).trim("v.")

   return @{ 
      Version = $version
      URL32   = "https://github.com$URLstub32"
      URL64   = "https://github.com$URLstub64"
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version:).*"     = "`${1} $($Latest.Version)"
            "(^- x86 URL:).*"     = "`${1} $($Latest.URL32)"
            "(^- x86 SHA256+:).*" = "`${1} $($Latest.Checksum32)"
            "(^- x64 URL:).*"     = "`${1} $($Latest.URL64)"
            "(^- x64 SHA256+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading RBTray $($Latest.Version) zip files"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
