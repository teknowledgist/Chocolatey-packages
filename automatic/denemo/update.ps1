import-module chocolatey-au

function global:au_GetLatest {
   $DownloadsPage = 'https://denemo.org/downloads-page/'
   $PageContent = Invoke-WebRequest -Uri $DownloadsPage

   $URL = $PageContent.links | Where-Object {$_.href -like '*.zip'} | Select-Object -First 1 -ExpandProperty href

   $version = $URL -replace '.*?(\d\.[0-9.]+).*','$1'

   return @{ 
            Version  = $Version.trim('.')
            URL32    = $URL
           }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -ChecksumFor all
