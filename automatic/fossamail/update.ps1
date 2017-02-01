import-module au

$StartPage = 'http://relmirror.fossamail.org'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $StartPage

   $folder = $download_page.links |? href -match '\d\d(\.\d)+' |select -First 1 -ExpandProperty href
   $NextPage = "$StartPage/$folder"
   $version = $folder.trim('/')

   $download_page = Invoke-WebRequest -Uri $NextPage
   $files = $download_page.links |? href -match 'installer.exe$' |select -ExpandProperty href


   return @{ 
            Version = $version
            URL32 = "$NextPage/" + $files[0]
            URL64 = "$NextPage/" + $files[1]
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