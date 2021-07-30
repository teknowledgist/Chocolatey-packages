import-module au

$Release = 'https://github.com/OpenRefine/OpenRefine/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.rawcontent.split() | 
                Where-Object {$_ -match 'win-with-java.*\.zip"'} |
                Select-Object -First 1
   $url = "https://github.com" + $($urlstub -replace '.*?"([^ ]+\.zip).*','$1')

   $version = $url.split('/') | ? {$_ -match '^[0-9.]+$'}

   return @{ 
      Version    = $Version
      URL32      = $url
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   URL\s+=).*"      = "`${1} '$($Latest.URL32)'"
         "(^   Checksum\s+=).*" = "`${1} '$($Latest.Checksum32)'"
      }
   }
}

Update-Package

