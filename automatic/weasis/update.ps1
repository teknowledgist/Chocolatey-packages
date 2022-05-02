import-module au

$Release = 'https://github.com/nroduit/Weasis/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match '\.msi"'} | Select-Object -First 1

   $URL64 = $urlstub -replace '.*?"([^ ]+\.msi).*','$1'

   $versionstring = $urlstub.split('/') | ? {$_ -match '^v?[0-9.]+'}
   $version = $versionstring.trim('v')

   return @{ 
      Version = $version
      URL64   = "https://github.com" + $URL64
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
            "(^Version\s+:).*"    = "`${1} $($Latest.Version)"
            "(^x64 URL\s+:).*"    = "`${1} $($Latest.URL64)"
            "(^x64 SHA256\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Weasis $($Latest.Version) installer files"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
