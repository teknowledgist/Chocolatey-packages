import-module au

$Global:au_NoCheckUrl = $true

function global:au_GetLatest {
   $Repo = 'https://github.com/debauchee/barrier'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL64 = $Release.Assets | Where-Object {$_.FileName -match '\.exe'} | Select-Object -ExpandProperty DownloadURL

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
