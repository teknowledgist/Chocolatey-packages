import-module chocolatey-au

$Release = 'https://sourceforge.net/projects/pydev/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $version = ($download_page.links |
                 Where-Object {$_.href -match 'latest'} | 
                 Select-Object -ExpandProperty title) -replace '^.*?([0-9.]*)\.zip.*','$1'

   $url = $Release + "files/pydev/PyDev%20$version/PyDev%20$version.zip"

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
   Write-host "Downloading PyDev $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix -FileNameBase "PyDev $($Latest.Version)"
}

update -ChecksumFor none
