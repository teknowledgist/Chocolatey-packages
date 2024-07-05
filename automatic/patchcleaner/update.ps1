import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'http://sourceforge.net/projects/patchcleaner/files'

   $download_page = Invoke-WebRequest -Uri $Release

   $URLstub = ($download_page.links |
                 Where-Object {$_.href -match 'latest'} | 
                 Select-Object -ExpandProperty title).split(':')[0]

   $version = $URLstub -replace '.*_([0-9.]+)\.[^0-9].*','$1'

   $url = $Release.replace('http:','https:') + $URLstub

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
   Write-host "Downloading PatchCleaner $($Latest.Version) installer."
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
