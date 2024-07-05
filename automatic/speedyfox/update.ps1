import-module chocolatey-au

$Release = 'https://www.crystalidea.com/speedyfox/release-notes'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $VerstionText = $download_page.AllElements | ? {$_.tagname -eq 'h2'} |select -First 1 -ExpandProperty innertext
   $Version = $VerstionText.trim().split()[-1]

   $url = 'https://www.crystalidea.com/downloads/speedyfox.zip'

   return @{ Version = $Version; URL = $url }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -ChecksumFor 32