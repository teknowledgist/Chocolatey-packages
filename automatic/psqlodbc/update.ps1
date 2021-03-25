import-module au

function global:au_GetLatest {
   $DownloadURI = 'https://www.postgresql.org/ftp/odbc/versions/msi/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $URLs = $download_page.links |
               Where-Object {$_.innertext -match '\.zip$'} |
               Select-Object -ExpandProperty href -last 3

   $url64 = $URLs | Where-Object {$_ -match '-x64'}
   $url32 = $URLs | Where-Object {$_ -match '-x86'}

   $Version = $urls[-1] -replace ".*?_([0-9_]+)\.zip",'$1' -replace '_','.'

   return @{ 
            Version  = $Version
            URL64    = $url64
            URL32    = $url32
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^32-bit URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^32-bit Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
         "(^64-bit URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^64-bit Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading psqlodbc $($Latest.AppVersion) zip files"
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
