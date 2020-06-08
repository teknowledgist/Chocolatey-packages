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
      "tools\VERIFICATION.txt" = @{
         "(^Milestone\s*=\s*)('.*')"       = "`$1$($Latest.Version)"
         "(^32-bit URL\s*=\s*)('.*')"      = "`$1$($Latest.URL32)"
         "(^64-bit URL\s*=\s*)('.*')"      = "`$1$($Latest.URL64)"
         "(^32-bit checksum\s*=\s*)('.*')" = "`$1$($Latest.Checksum32)"
         "(^64-bit checksum\s*=\s*)('.*')" = "`$1$($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading MiKTeX setup utility $($Latest.AppVersion) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
