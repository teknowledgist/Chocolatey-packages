import-module au

$Release = 'https://github.com/JulietaUla/Montserrat/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.rawcontent.split('"') | 
                  Where-Object {$_ -match '\.zip'} | Select-Object -First 1

   $version = $urlstub.trim('.zip').split('/')[-1].trim('v')

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
   Write-host "Downloading Montserrat font $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
