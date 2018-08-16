import-module au

$StartPage = 'https://www.safer-networking.org/spybot-anti-beacon/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $StartPage

   $link = $download_page.links | ? {$_.innertext -match '^Download.*(installer)'}

   $version = $link.innertext -replace '.+ v([0-9.]+) .+','$1'

   return @{ 
            Version = $version
            URL32 = $link.href
           }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
         "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package