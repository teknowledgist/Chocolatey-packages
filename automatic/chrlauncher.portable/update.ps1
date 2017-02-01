import-module au

$Release = 'https://github.com/henrypp/chrlauncher/releases/latest'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $regex = 'chrlauncher-.*?-bin.zip'
   $urlstub = $download_page.links |Where-Object {$_.href -match $regex} |Select-Object -ExpandProperty href
   $url = "https://github.com/$urlstub"

   $version = ($urlstub -split '-')[1]

   return @{ Version = $version; URL = $url }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
         "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
         "(^[$]version\s*=\s*)('.*')"      = "`$1'$($Latest.version)'"
      }
      "tools\chocolateyUninstall.ps1" = @{
         "(^[$]version\s*=\s*)('.*')"      = "`$1'$($Latest.version)'"
      }
   }
}

Update-Package -ChecksumFor 32