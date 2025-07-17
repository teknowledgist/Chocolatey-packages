import-module chocolatey-au

function global:au_GetLatest {
   $DownloadURI = 'https://download.slicer.org/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($download_page.rawcontent)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($download_page))   # No MS Office
   }

   $TRow = $HTML.getElementsByTagName('tr') | 
               Where-Object {$_.innertext -match 'stable release'} | 
               Select-Object -ExpandProperty innerhtml
   $TData = $TRow -split '</?T[DH]>' | Where-Object {$_ -match 'revision'} | Select-Object -First 1

   $HREF = ($TData -replace '.*"/bitstream/([^"]+)".*','$1').trim()
   $version = ($TData -replace '.*>([0-9.]+).*','$1').trim()
   $revision = ($TData -replace '.*revision ([0-9.]+).*','$1').trim()

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
      "tools\chocolateyBeforeModify.ps1" = @{
         "(^   softwarename\s*=\s*)('.*')"   = "`$1'Slicer $($Latest.NamedVersion)*'"
      }
   }
}


update -ChecksumFor 64
