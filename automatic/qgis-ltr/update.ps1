import-module chocolatey-au

function global:au_GetLatest {
   $BaseURL = "https://www.qgis.org"
   $DownloadURI = "$BaseURL/download/"
   $PageText = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($PageText.rawcontent)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($PageText))   # No MS Office
   }

   $null = $PageText.content.split("`n") | Where-Object {$_ -cmatch 'long-term (repositories|builds) currently offer QGIS ([0-9.]*)'}
   
   $LTRRelease = $Matches[2]

   $url = $PageText.Links | 
              Where-Object {$_.href -match "$LTRRelease.*\.msi`$"} | 
              Select-Object -ExpandProperty href

   $SumURL = $url -replace '\.msi$','.sha256sum'
   
   $SumFile = "$env:temp\QGIS$LTRRelease-SHA256.txt"
   Invoke-WebRequest "$BaseURL$SumURL" -OutFile $SumFile
   $Checksum64 = (Get-Content $SumFile -ReadCount 1).split()[0]

   return @{ 
            Version      = $LTRRelease
            AppVersion   = $LTRRelease
            URL64        = "$BaseURL$url"
            Checksum64   = $Checksum64
           }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]AppVersion = )('.*')"     = "`$1'$($Latest.AppVersion)'"
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
      "qgis-ltr.nuspec" = @{
         "^(\s*<releaseNotes>.*log)\d\d\d?(<\/releaseNotes>)" = "`${1}$(([version]($Latest.AppVersion)).tostring(2).Replace('.',''))`$2"
      }
   }
}

Update-Package -ChecksumFor none -NoCheckChocoVersion
