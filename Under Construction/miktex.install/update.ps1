import-module au

function global:au_GetLatest {
   $DownloadPageURL = 'https://miktex.org/download'

   $DownloadPage = Invoke-WebRequest -Uri $DownloadPageURL

   $URLstubs = $DownloadPage.links | 
                  Where-Object {$_.href -match 'zip'} | 
                  Select-Object -ExpandProperty href -Unique

   $url32 = 'https://miktex.org' + ($URLstubs | Where-Object {$_ -notmatch 'x64'})
   $url64 = 'https://miktex.org' + ($URLstubs | Where-Object {$_ -match 'x64'})

   # The version number in the url is the version of the setup utility, but not
   #   the "milestone" of the MiKTeX core run-time library.
   $LatestRelease = 'https://github.com/MiKTeX/miktex/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $LatestPage = Invoke-WebRequest -Uri $LatestRelease -UseBasicParsing
   $CodeURL = $LatestPage.Links | 
                  Where-Object {$_.href -match 'zip$'} | 
                  Select-Object -ExpandProperty href
   $milestone = $CodeURL.trim('.zip').split('/')[-1]

   return @{ 
      Version = $milestone
      URL32   = $url32 
      URL64   = $url64 
   }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^\s*Url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^\s*Url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

update 