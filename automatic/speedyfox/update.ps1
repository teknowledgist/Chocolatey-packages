import-module chocolatey-au


function global:au_GetLatest {
   $Release = 'https://www.crystalidea.com/speedyfox/release-notes'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $VersionText = $download_page.rawcontent -split '</?h2>' | select -First 1
   $Version = $VersionText.trim().split()[-1] -replace '.*?([0-9.]+).*','$1'

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