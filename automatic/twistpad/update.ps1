import-module chocolatey-au

function global:au_GetLatest {
   $DownloadURI = "https://www.carthagosoft.net/TwistpadDownload.php"
   $PageText = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($PageText)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($PageText))   # No MS Office
   }

   $DloadVersion = $html.links | Where-Object {$_.href -match 'downloadfree'} | Select-Object -First 1 -ExpandProperty textcontent
   $version = ($DloadVersion.split() | Where-Object {$_ -match '^v?[0-9.]+$'}) -replace 'v',''

   return @{ 
            Version = $version
            URL32   = "https://www.carthagosoft.net/downloads/TwistpadSetup.zip"
           }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   URL\s*=\s*)('.*')"   = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -ChecksumFor 32 -NoCheckChocoVersion
