import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://docfetcher.sourceforge.io/en/download.html'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release

   $Filename = $download_page.links | 
                  Where-Object {$_.href -like '*.exe*'} | 
                  Select-Object -ExpandProperty innertext

   $version = $Filename -replace '.*_([0-9.]+)_.*','$1'

   $url = "https://sourceforge.net/projects/docfetcher/files/docfetcher/$version/$FileName"

   return @{ 
      Version = $version
      URL32 = $url
   }
}


function global:au_SearchReplace {
   @{
      'legal\VERIFICATION.md' = @{
         '(^- Version\s*:).*'      = "`${1} $($Latest.Version)"
         '(^- URL\s*:).*'          = "`${1} $($Latest.URL32)"
         '(^- Checksum\s*:).*'     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading DocFetcher v$($Latest.Version) installer files."
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
