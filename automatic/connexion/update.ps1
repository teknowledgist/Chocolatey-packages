import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://help.oclc.org/Librarian_Toolbox/Software_downloads/Download_cataloging_software?sl=en'
   $download_page = Invoke-WebRequest -Uri "$Release" -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $HTML.IHTMLDocument2_write($download_page.rawcontent)    # if MS Office installed
   } catch {
      $HTML.write([Text.Encoding]::Unicode.GetBytes($download_page))   # No MS Office
   }

   $Link = $HTML.links |
               Where-Object {($_.href -match 'connex.*\.exe')} |
               Select-Object -First 1

   $url = $Link.href
   $version = $link.title.trim('.exe') -replace '[^0-9.]',''

   return @{ 
      Version = $version
      URL32 = $url
   }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^\s*Url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^\s*Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

Update-Package