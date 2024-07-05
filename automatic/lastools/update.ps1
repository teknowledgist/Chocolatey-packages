import-module chocolatey-au

function global:au_GetLatest {
   $MainPage = Invoke-WebRequest -Uri 'https://lastools.github.io/download/CHANGES.txt'

   $version = get-date ($mainpage.content.split('-')[0]) -format yyyy.MM.dd

   $url = 'https://lastools.github.io/download/LAStools.zip'

   return @{ 
            Version = $version
            URL = $url
           }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]checkSum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -NoCheckChocoVersion