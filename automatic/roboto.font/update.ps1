import-module au

$Release = 'https://github.com/googlefonts/roboto/releases'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstring = $download_page.rawcontent.split(' ') | 
                  Where-Object {$_ -match 'href.*-hinted\.zip'} | Select-Object -First 1
   $urlstub = $urlstring.trim('"').split('"')[-1]

   $version = $urlstub.split('/').trim('v') | Where-Object {$_ -match '^[0-9.]+$'}

   return @{ 
      Version = $version
      URL32     = "https://github.com$urlstub"
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
            "(^Version\s+:).*" = "`${1} $($Latest.Version)"
            "(^URL\s+:).*"     = "`${1} $($Latest.URL32)"
            "(^SHA256\s+:).*"  = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Roboto font $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
