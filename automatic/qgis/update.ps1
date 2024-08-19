import-module chocolatey-au

function global:au_GetLatest {
   $BaseURL = "https://www.qgis.org"

   $DownloadURI = "$BaseURL/en/site/forusers/download.html"
   $PageText = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($PageText)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($PageText))   # No MS Office
   }

   $null = $PageText.content.split("`n") | Where-Object {$_ -cmatch 'current version is QGIS ([0-9.]*)'}
   
   $NewVersion = $Matches[1]

   $urlstub = $PageText.Links | 
              Where-Object {$_.href -match "$NewVersion.*\.msi`$"} | 
              Select-Object -ExpandProperty href
   $url = $BaseURL + $urlstub

   $SumURL = $url -replace '\.msi$','.sha256sum'
   
   $SumFile = "$env:temp\QGIS$NewVersion-SHA256.txt"
   Invoke-WebRequest $SumURL -OutFile $SumFile
   $Checksum64 = (Get-Content $SumFile -ReadCount 1).split()[0]

   $null = $PageText.content.split("`n") | Where-Object {$_ -cmatch 'long-term (repositories|builds) currently offer QGIS ([0-9.]*)'}
   $LTRversion = $Matches[2]

   return @{ 
      Version    = $NewVersion
      LTRVersion = $LTRversion
      URL64      = $url
      Checksum64 = $Checksum64
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]LTRversion = )('.*')"     = "`$1'$($Latest.LTRversion)'"
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -NoCheckUrl -ChecksumFor none