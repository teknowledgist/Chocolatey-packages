import-module au

$Release = 'https://github.com/White-Tiger/T-Clock/releases'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.links |? {$_.href -match '.7z$'} | select -ExpandProperty href -First 1
   $url = "https://github.com$urlstub"

   $version = $urlstub -replace '.*download\/v([1-9.%]+).*','$1' -replace '%23','.'

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      'tools\VERIFICATION.txt' = @{
         '(^Version\s+:).*'      = "`${1} $($Latest.Version)"
         '(^URL\s+:).*'          = "`${1} $($Latest.URL32)"
         '(^Checksum\s+:).*'     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading T-Clock $($Latest.Version) zip file."
   Get-RemoteFiles -Purge -NoSuffix -FileNameBase 'T-Clock'
}

update -ChecksumFor none
