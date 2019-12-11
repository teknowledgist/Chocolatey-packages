import-module au

$Release = 'https://github.com/synfig/synfig/releases'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstubs = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match '\.exe"'} | Select-Object -First 2

   $url32 = ($urlstubs | Where-Object {$_ -match 'win32'}) -replace '.*?"([^ ]+\.exe).*','$1'
   $url64 = ($urlstubs | Where-Object {$_ -match 'win64'}) -replace '.*?"([^ ]+\.exe).*','$1'

   $version = ($url64.split('/') | Where-Object {$_ -match '^v[0-9.]+$'}).trim('v')

   if ($url64 -match 'testing') {
      $version = $version + '-beta'
   }

   return @{ 
      Version = $version
      URL32   = "https://github.com" + $url32
      URL64   = "https://github.com" + $url64
   }
}


function global:au_SearchReplace {
   @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
          "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
          "(^\s*Url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
          "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package
