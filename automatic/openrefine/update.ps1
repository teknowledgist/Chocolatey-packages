import-module au

function global:au_GetLatest {
   $Release = 'https://github.com/OpenRefine/OpenRefine/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstring = $download_page.rawcontent.split() | 
                Where-Object {$_ -match 'win-with-java.*zip"'} |
                Select-Object -First 1
   $url = ($urlstring.split('"') | ? {$_ -like 'https*'}) -replace '&amp;','&'

   $version = $url -replace '.*v=([0-9.]+).*','$1'

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

