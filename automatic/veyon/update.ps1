import-module au

$Release = 'https://github.com/veyon/veyon/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstubs = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match '\.exe"'} | Select-Object -First 2

   $url32 = ($urlstubs | Where-Object {$_ -match 'win32'}) -replace '.*?"([^ ]+\.exe).*','$1'
   $url64 = ($urlstubs | Where-Object {$_ -match 'win64'}) -replace '.*?"([^ ]+\.exe).*','$1'

   $version = $url64.split('-') | Where-Object {$_ -match '^[0-9.]+$'} |select -Last 1

   return @{ 
      Version = $version
      URL32   = "https://github.com" + $url32
      URL64   = "https://github.com" + $url64
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
            "(^Version\s+:).*"    = "`${1} $($Latest.Version)"
            "(^URL\s+:).*"        = "`${1} $($Latest.URL32)"
            "(^Checksum\s+:).*"   = "`${1} $($Latest.Checksum32)"
            "(^URL64\s+:).*"      = "`${1} $($Latest.URL64)"
            "(^Checksum64\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Veyon $($Latest.Version) installer files"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
