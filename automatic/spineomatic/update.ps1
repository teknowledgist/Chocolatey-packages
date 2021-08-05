import-module au

$Release = 'https://github.com/ExLibrisGroup/SpineOMatic/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $href = $download_page.rawcontent.split("") | Where-Object {$_ -match 'href.*\.exe'}

   $url = "https://github.com" + $href.trim('"').split('"')[-1]

   $version = $url -replace ".*/v?([0-9.]+)/.*",'$1'

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      'tools\VERIFICATION.txt' = @{
         '(^Version\s+:).*'      = "`${1} $($Latest.Version)"
         '(^URL\s+:).*'          = "`${1} $($Latest.URL32)"
         '(^SHA256\s+:).*'     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading SpineOMatic $($Latest.Version) 'spinelabeler.exe' file."
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
