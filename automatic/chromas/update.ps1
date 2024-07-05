import-module chocolatey-au

function global:au_GetLatest {
   $DownloadURI = 'http://technelysium.com.au/wp/chromas/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $Link = $download_page.links |? {($_.href -match '\.exe') -and ($_.outertext -match 'free')}
   
   $version = $Link.innerText.split() | ? {$_ -match '^[0-9.]+$'}

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
