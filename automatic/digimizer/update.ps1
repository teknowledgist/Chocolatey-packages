import-module chocolatey-au

function global:au_GetLatest {
   $MainPage = 'https://www.digimizer.com'

   $HistoryPage = Invoke-WebRequest -Uri "$MainPage/history.php"
   $VersionString = $HistoryPage.AllElements | 
                        Where-Object {$_.tagname -eq 'h2' -and $_.innertext -match '^Version'} |
                        Select-Object -ExpandProperty innertext -First 1
   $HistoryVersion = $VersionString.split(' ')[-1]
   if ($HistoryVersion.length -eq 1) { $HistoryVersion = "$Version.0.0" }

   $DownloadPage = Invoke-WebRequest -Uri "$MainPage/download/"
   $VersionString = $DownloadPage.AllElements | 
                        Where-Object {$_.tagname -eq 'h1' -and $_.innertext -match 'Version ([0-9.]+)'} |
                        Select-Object -ExpandProperty innertext -First 1
   $DownloadVersion = $Matches[1]
   if (-not $DownloadVersion) { $DownloadVersion = '1.0' }
   
   If ([version]$HistoryVersion -ge [version]$DownloadVersion) {
      $Version = $HistoryVersion
   } else { $Version = $DownloadVersion }

   $DownloadPage = Invoke-WebRequest -Uri "$MainPage/download/"
   $urlstub = $DownloadPage.links | Where-Object {$_.href -like '*.msi'} | Select-Object -ExpandProperty href -first 1
   $url = $MainPage + "/download/" + $urlstub

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