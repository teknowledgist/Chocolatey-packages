import-module chocolatey-au

function global:au_GetLatest {
   $SIVhist = 'http://rh-software.com/index_arc.html'
   $HistPage = Invoke-WebRequest -Uri $SIVhist -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($HistPage.rawcontent)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($HistPage))   # No MS Office
   }

   $txt = $HTML.getElementsByTagName('b') | Where-Object {$_.innertext -match '^version'} |
               Select-Object -First 1 -ExpandProperty innertext
   $Version = $txt.tostring().split()[-1]

   $mirror = 'https://www.filecroco.com/download-system-information-viewer/download/'
   $downpage = Invoke-WebRequest $mirror

   $URL = $downpage.links | ? {$_.innertext -eq 'download now'} | select -ExpandProperty href

   return @{ 
         Version  = $version
         URL32    = $URL
         FileType = 'zip'
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^- URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^- Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}
function global:au_BeforeUpdate() { 
   Write-host "Downloading SIV $($Latest.Version) zip file."
   Get-RemoteFiles -Purge -NoSuffix -FileNameBase "siv_v$($Latest.Version)"
}

Update-Package -ChecksumFor none
