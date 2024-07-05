import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://www.xnview.com/en/xnviewmp/'
   $download_page = Invoke-WebRequest -Uri $Release

   $URL64 = $download_page.links |
               Where-Object {$_.href -match 'x64\.zip'} |
               Select-Object -First 1 -ExpandProperty href

   $null = $download_page.content -match 'Download <.+?>XnView MP ([0-9.]+)<'
   $Version = $Matches[1]

   return @{ 
            Version = $Version
            URL64   = $URL64
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
