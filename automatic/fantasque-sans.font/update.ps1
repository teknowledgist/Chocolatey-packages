import-module au

function global:au_GetLatest {
   $Release = 'https://github.com/belluzj/fantasque-sans/releases/latest'
   
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match 'normal.zip"'} |
                Select-Object -First 1
   $url = "https://github.com" + $($urlstub -replace '.*?"([^ ]+\.zip).*','$1')

   $version = $urlstub -replace '.*download\/v([0-9.]+).*','$1'

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      'tools\VERIFICATION.txt' = @{
         '(^Version\s+:).*'      = "`${1} $($Latest.Version)"
         '(^URL\s+:).*'          = "`${1} $($Latest.URL32)"
         '(^Checksum\s+:).*'     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Fantasque-Sans-Mono $($Latest.Version) zip file."
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
