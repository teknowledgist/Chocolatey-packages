import-module au

$DownloadURI = 'https://www.qgis.org/en/site/forusers/download.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $null = $download_page.content.split("`n") | Where-Object {$_ -cmatch 'current version is QGIS ([0-9.]*)'}
   
   $NewVersion = $Matches[1]

   $url = $download_page.Links | 
              Where-Object {$_.href -match "$NewVersion.*\.msi`$"} | 
              Select-Object -ExpandProperty href

   $SumURL = $download_page.Links |
        Where-Object {$_.href -match "$NewVersion.*\.sha256sum`$"} |
        Select-Object -ExpandProperty href
   $SumFile = "$env:temp\QGIS$NewVersion-SHA256.txt"
   Invoke-WebRequest $SumURL -OutFile $SumFile
   $Checksum64 = (Get-Content $SumFile -ReadCount 1).split()[0]

   $null = $download_page.content.split("`n") | Where-Object {$_ -cmatch 'long-term repositories currently offer QGIS ([0-9.]*)'}
   $LTRversion = $Matches[1]


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