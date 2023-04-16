import-module au

function global:au_GetLatest {
   $DownloadURI = 'https://download.slicer.org/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $TRow = $download_page.ParsedHtml.getElementsByTagName('tr') | 
               Where-Object {$_.innertext -match 'stable release'} | 
               Select-Object -ExpandProperty innerhtml
   $TData = $TRow -split '</?T[DH]>' | Where-Object {$_ -match 'revision'} | Select-Object -First 1

   $HREF = $TData -replace '.*"/bitstream/([^"]+)".*','$1'
   $version = $TData -replace '.*>([0-9.]+).*','$1'
   $revision = $TData -replace '.*revision ([0-9.]+).*','$1'

   $url64 = "https://slicer-packages.kitware.com/api/v1/item/$HREF/download"

   return @{ 
            Version      = "$version.$revision"
            NamedVersion = $version
            URL64        = $url64
         }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
      "tools\chocolateyUninstall.ps1" = @{
         "(^   softwarename\s*=\s*)('.*')"   = "`$1'Slicer $($Latest.NamedVersion)*'"
      }
   }
}


update -ChecksumFor 64
