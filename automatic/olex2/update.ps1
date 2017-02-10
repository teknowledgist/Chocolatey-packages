import-module au

$Release = 'http://www.olex2.org/olex2-distro/1.2/update/version.txt'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $Revision = $download_page.Content -replace "^.*?(\d+)$",'$1'
   $version = '1.2.8.' + $Revision

   $url32 = 'http://www.olex2.org/olex2-distro/1.2/olex2-win32.zip'
   $url64 = 'http://www.olex2.org/olex2-distro/1.2/olex2-win64.zip'

   return @{ 
            Version = $version
            URL32 = $url32
            URL64 = $url64
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