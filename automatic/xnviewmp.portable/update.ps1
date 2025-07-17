import-module chocolatey-au

function global:au_GetLatest {
   $DownMPurl = 'https://www.xnview.com/en/xnview-mp/'
   $Downpage = Invoke-WebRequest -Uri $DownMPurl -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($Downpage.rawcontent)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($Downpage))   # No MS Office
   }
   
   $VersionText = $HTML.getElementsByTagName('strong') |
                     Where-Object {$_.innertext -match 'XnView MP'} | 
                     Select-Object -ExpandProperty innertext -First 1
   $Version = $VersionText.split() | Where-Object {$_ -match '^[0-9.]+$'}

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
