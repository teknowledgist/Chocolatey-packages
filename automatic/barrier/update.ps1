import-module au

$Global:au_NoCheckUrl = $true

function global:au_GetLatest {
   $DownloadURI = 'https://github.com/debauchee/barrier/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing

   $urlstub = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match '\.exe"'} | Select-Object -First 1

   $url64 = $urlstub -replace '.*?"([^ ]+\.exe).*','$1'

   $version = $url64.split('/') | Where-Object {$_ -match '^v[0-9.]+$'} |select -Last 1
   $version = $version.trim('v')
   
   return @{ 
            Version  = $version
            URL64    = "https://github.com" + $url64
            Options  = @{
               Headers = @{
                  ContentType = 'application/octet-stream'
               }
            }
         }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL64)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Get-RemoteFiles -Purge -NoSuffix
}


update -ChecksumFor none
if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
