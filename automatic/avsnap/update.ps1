import-module chocolatey-au

function global:au_GetLatest {
   $DownloadURI = 'https://avsnap.com/release-notes/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing

   $null = $download_page.RawContent -split '</?br ?/?>' | 
               Where-Object { $_ -match '^version ([0-9.]+)' } | Select-Object -First 1
   $Version = $Matches[1]

   $url = 'https://www.avsnap.com/software/AVSnap_Setup.exe'

   return @{ 
            Version = $version
            URL32   = $url
         }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
   }
}


update -ChecksumFor 32
