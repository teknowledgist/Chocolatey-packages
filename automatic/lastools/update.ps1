import-module au

function global:au_GetLatest {
   $WebClient = New-Object System.Net.WebClient
   $string = $WebClient.DownloadString('http://www.cs.unc.edu/~isenburg/lastools/download/CHANGES.txt')
   $version = get-date ([datetime]($string.split("`n")[0] -replace "--.*",'')) -format yyyy.MM.dd

   $url = 'http://lastools.org/download/LAStools.zip'

   return @{ 
            Version = $version
            URL = $url
           }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
         "(^[$]checkSum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package