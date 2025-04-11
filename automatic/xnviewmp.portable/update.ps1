import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://www.xnview.com/en/xnviewmp/'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($download_page.rawcontent)    # if MS Office installed
   }
   catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($download_page))   # No MS Office
   }
   
   $VersionText = $HTML.getElementsByTagName("p") |
      Where-Object { $_.innertext -match 'Download XnView MP ([0-9.]+)' } | 
      Select-Object -ExpandProperty innertext -First 1
   $Version = $Matches[1]

   $DownStub = $HTML.links |
      Where-Object { $_.href -match 'x64\.zip' } |
      Select-Object -First 1 -ExpandProperty nameprop
   $URL = "https://www.xnview.com/$DownStub"

   return @{ 
      Version = $Version
      URL64   = $URL
   }
}


function global:au_SearchReplace {
    @{
      'tools\chocolateyinstall.ps1' = @{
         '^(\s+Url64bit\s+=).*'   = "`${1} '$($Latest.URL64)'"
         '^(\s+Checksum64\s+=).*' = "`${1} '$($Latest.Checksum64)'"
      }
    }
}


update -ChecksumFor 64
