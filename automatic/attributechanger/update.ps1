import-module au

$Global:au_NoCheckUrl = $true

function global:au_GetLatest {
   $DownloadURI = 'https://www.petges.lu/download/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $Link = $download_page.links |? {$_.href -match '\.exe'} | select -First 1
   
   $version = $Link.innerText.split()[-1]
   
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
                  ContentType = 'application/octet-stream'
               }
            }
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
   Write-host "Downloading Attribute Changer $($Latest.Version)"
   Write-warning "The Attribute Changer site won't allow proper download.  It must be manually downloaded."
   Get-RemoteFiles -Purge -NoSuffix
}


update -ChecksumFor none
if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
