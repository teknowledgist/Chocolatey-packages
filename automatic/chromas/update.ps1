import-module chocolatey-au

function global:au_GetLatest {
   $DownloadURI = 'http://technelysium.com.au/wp/chromas/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing

   $Link = $download_page.links | Where-Object {
                        ($_.href -match '\.exe') -and 
                        ($_.outerHTML -match 'free')
                        }
   
   $version = $Link.outerHTML.split(' ') | Where-Object {$_ -match '^[0-9.]+$'}

   $url32 = $Link.href

   return @{ 
      Version  = $version
      URL32    = $url32
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Chromas $($Latest.Version)"
   Get-RemoteFiles -Purge -NoSuffix
}


update -ChecksumFor none
if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
