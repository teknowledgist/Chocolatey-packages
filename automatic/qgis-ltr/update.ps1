import-module au

$DownloadURI = 'https://www.qgis.org/en/site/forusers/download.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $null = $download_page.content.split("`n") | Where-Object {$_ -cmatch 'long-term repositories currently offer QGIS ([0-9.]*)'}
   
   $LTRRelease = $Matches[1]

   $url = $download_page.Links | 
              Where-Object {$_.href -match "$LTRRelease.*\.msi`$"} | 
              Select-Object -ExpandProperty href

   $SumURL = $url -replace '\.msi$','.sha256sum'
   
   $SumFile = "$env:temp\QGIS$LTRRelease-SHA256.txt"
   Invoke-WebRequest $SumURL -OutFile $SumFile
   $Checksum64 = (Get-Content $SumFile -ReadCount 1).split()[0]

   return @{ 
            Version      = $LTRRelease
            AppVersion   = $LTRRelease
            URL64        = $url
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
