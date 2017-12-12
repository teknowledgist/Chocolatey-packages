import-module au

$Release = 'https://sourceforge.net/projects/tinycad/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $File = ($download_page.links |
                 ? {$_.href -match 'latest'} | 
                 select -ExpandProperty title) -replace '^.*/(.*\.exe).*','$1'
   $url = $Release + "files/$File"

   $version = $File -replace "[^0-9]+([0-9._]*)_.*",'$1' -replace '_','.'
   
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
   Write-host "Downloading TinyCAD $($Latest.Version)."
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
