import-module au

$Release = 'http://www.textworld.com/scp/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $link = $download_page.links | 
            Where-Object {$_.href -like "*.exe"} | 
            Select-Object -First 1   
            
   $url = $Release + $link.href

   $version = $link.innerText -replace '[^0-9]*(.*[0-9])\).*','$1' -replace '[^0-9.]+','.'

   return @{ Version = $version; URL32 = $url }
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
   Write-host "Downloading SCP $($Latest.Version) zip file."
   Get-RemoteFiles -Purge
}

update -ChecksumFor none
