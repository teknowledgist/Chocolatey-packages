import-module au

function global:au_GetLatest {
   $Release = 'https://sourceforge.net/projects/zint/'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release

   $versionstring = ($download_page.links |
                 Where-Object {$_.href -match 'latest'} | 
                 Select-Object -ExpandProperty title)
   $version = $versionstring -replace '^.*?-([0-9.]+)-.*','$1'

   $url = $Release + "files/zint/$version/zint-$version-win32.zip"

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      'legal\VERIFICATION.md' = @{
         '(^- Version\s*:).*'      = "`${1} $($Latest.Version)"
         '(^- URL\s*:).*'          = "`${1} $($Latest.URL32)"
         '(^- Checksum\s*:).*'     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Zint $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
