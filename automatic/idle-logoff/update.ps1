import-module au

function global:au_GetLatest {
   $Release = 'https://github.com/lithnet/idle-logoff/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $URLtxt = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match '\.msi"'} | Select-Object -First 1

   $URLstub = ($URLtxt | Where-Object {$_ -match '\.msi'}) -replace '.*?"([^ ]+\.msi).*','$1'

   $version = ($URLstub.tostring().split('/') | Where-Object {$_ -match '^v[0-9.]+$'}).trim("v")

   return @{ 
      Version = $version
      URL32   = "https://github.com$URLstub"
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version:).*"          = "`${1} $($Latest.Version)"
            "(^- URL:).*"              = "`${1} $($Latest.URL32)"
            "(^- SHA256 Checksum+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Idle-Logoff $($Latest.Version) installer files"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
