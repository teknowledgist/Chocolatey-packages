import-module au

function global:au_GetLatest {
   $Release = 'https://www.freefilesync.org/download.php'

   $download_page = Invoke-WebRequest -Uri $Release

   $URLstub = $download_page.links |
                 Where-Object {$_.href -match '\.exe$'} | 
                 Select-Object -ExpandProperty href

   $version = $URLstub -replace '.*_([0-9.]+)_.*','$1'

   $url = 'https://www.freefilesync.org' + $URLstub

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
   Write-host "Downloading FreeFileSync $($Latest.Version) installer."
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
