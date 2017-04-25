import-module au

$RootURL = 'https://ipmsg.org'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$RootURL/tools/fastcopy.html.en"

   $path64,$path32 = $download_page.links |? innertext -eq 'installer' |select -First 2 -ExpandProperty href

   $Text = $download_page.allelements |? {
                                   ($_.tagname -eq 'th') -and 
                                   ($_.innertext -match "FastCopy.*download")
                                } | select -First 1 -ExpandProperty innertext
    
   $version = $Text -replace ".*v([\d\.]*).*",'$1'

   return @{ 
            Version = $version
            URL32 = $RootURL + $path32
            URL64 = $RootURL + $path64
           }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
         "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
         "(^[$]checkSum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
         "(^[$]checkSum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package