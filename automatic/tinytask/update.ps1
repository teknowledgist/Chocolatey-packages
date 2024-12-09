import-module chocolatey-au

function global:au_GetLatest {
   $DownloadURI = 'https://www.tinytask.net/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($download_page)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($download_page))   # No MS Office
   }

   $Vtext = $HTML.links | 
               Where-Object {$_.innertext -match '^Version'} | 
               Select-Object -first 1 -ExpandProperty innertext

   $Version = $Vtext.split()[-1]

   $url = "https://github.com/frankwick/t/raw/main/tinytask.zip"

   return @{ 
            Version = $version
            URL32   = $url
         }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
   }
}


update -ChecksumFor 32
