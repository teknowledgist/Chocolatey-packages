import-module au


function global:au_GetLatest {
   $Release = 'https://www.venea.net/cdn/push/nettraffic'
   $download_page = Invoke-WebRequest -Uri $Release

   $version = $download_page.content.split()[1].trim('.zip')

   $url = 'https://www.venea.net/cdn/pull/nettraffic'

   return @{ Version = $Version; URL = $url }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -ChecksumFor 32 -nocheckchocoversion