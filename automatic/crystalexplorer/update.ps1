import-module au


function global:au_GetLatest {
   $DPageURL = 'https://www.crystalexplorer.net/download.html'
   $download_page = Invoke-WebRequest -Uri $DPageURL

   $URL64 = $download_page.Links | 
               Where-Object {$_.href -like "*.exe" } |
               Select-Object -ExpandProperty href -First 1

   $version = $URL64.split('-')[1]

   return @{ Version = $version; URL64 = $URL64 }
}


function global:au_SearchReplace {
    @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
    }
}

update -ChecksumFor 64