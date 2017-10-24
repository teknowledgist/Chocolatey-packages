import-module au

$Release = 'https://sourceforge.net/projects/jmol/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $version = ($download_page.links |
                 ? {$_.href -match 'latest'} | 
                 select -ExpandProperty title) -replace '^.*/[^0-9]*([0-9.]*).*','$1'
   $url = $Release + "files/Jmol-$Version-binary.zip"

   $ReleaseNotes = $Release + 'files/Jmol/Version%20' + 
                              ($version.split('.')[0..1] -join '.') + 
                              '/Version%20' + $version + '/'

   return @{ Version = $version; URL32 = $url; RNotes = $ReleaseNotes }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
      "jmol.nuspec" = @{
         "^(\s*<releaseNotes>).*(<\/releaseNotes>)" = "`$1$($Latest.RNotes)`$2"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Jmol-$($Latest.Version)-binary.zip"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
