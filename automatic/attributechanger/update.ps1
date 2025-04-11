import-module chocolatey-au

$Global:au_NoCheckUrl = $true

function global:au_GetLatest {
   $DownloadURI = 'https://www.petges.lu/download/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $Link = $download_page.links |Where-Object {$_.href -match '\.exe'} | Select-Object -First 1
   
   $Release = $download_page.RawContent.split('><') | ? {$_ -match '^release'} | select -first 1
   $version = $Release.split()[-1]
   
   if ($version -match '[a-z]') {
      $NumEquiv = ([byte][char]$matches[0])-96
      $version = $version -replace '[a-z]',".$NumEquiv"
   }

   $url32 = $Link.href

   return @{ 
            Version  = $version
            URL32    = $url32
            Options  = @{
               Headers = @{
                  'authority'='www.petges.lu'
                  'referer' = 'https://www.petges.lu/download/'
               }
            }
         }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^- Version:\s+).*"   = "`${1}$($Latest.Version)"
         "(^- URL:\s+).*"       = "`${1}$($Latest.URL32)"
         "(^- SHA256:\s+).*"    = "`${1}$($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Attribute Changer $($Latest.Version)"
   Get-RemoteFiles -Purge -NoSuffix
}


update -ChecksumFor none
if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
