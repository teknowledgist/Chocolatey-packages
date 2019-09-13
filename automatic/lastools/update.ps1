import-module au

function global:au_GetLatest {
   $MainPage = Invoke-WebRequest -Uri 'https://lastools.github.io/'
   $text = $MainPage.AllElements | ? {$_.tagname -eq 'p' -and $_.innertext -match 'download.*txt'} |select -ExpandProperty innertext

   $null = $text -match '[a-z]+ \d\d?[snrt][tdh] 20\d\d'
   $version = get-date ($matches[0] -replace '(\d\d)[snrt][tdh]','$1') -format yyyy.MM.dd

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