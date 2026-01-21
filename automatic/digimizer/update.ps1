import-module chocolatey-au

function global:au_GetLatest {
   $MainPage = 'https://www.digimizer.com'

   $HistoryPage = Invoke-WebRequest -Uri "$MainPage/history.php" -UseBasicParsing

   $null = $HistoryPage.rawcontent -split '<\/?h2' | 
                  Where-Object {$_ -match '>Version ([0-9.]+)'} | 
                  Select-Object -first 1
   $HistoryVersion = $matches[1]
   if ($HistoryVersion.length -eq 1) { $HistoryVersion = "$Version.0.0" }

   $DownloadPage = Invoke-WebRequest -Uri "$MainPage/download/" -UseBasicParsing

   $null = $DownloadPage.rawcontent -split '<\/?h1' | 
                        Where-Object {$_ -match '>Version ([0-9.]+)'} |
                        Select-Object -First 1
   $DownloadVersion = $Matches[1]
   if (-not $DownloadVersion) { $DownloadVersion = '1.0' }
   
   If ([version]$HistoryVersion -ge [version]$DownloadVersion) {
      $Version = $HistoryVersion
   } else { $Version = $DownloadVersion }

   $urlstub = $DownloadPage.links | Where-Object {$_.href -like '*.msi'} | Select-Object -ExpandProperty href -first 1
   if (-not $urlstub) {
      $urlstub = $DownloadPage.links | Where-Object { $_.href -like '*.exe' } | Select-Object -ExpandProperty href -first 1
   }
   $url = "$MainPage/download/$urlstub"

   return @{ Version = $version; URL = $url }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^   url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^   Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

update -ChecksumFor 32