import-module chocolatey-au

$Release = 'http://code.kliu.org/cmdopen/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $AppVersion = $download_page.AllElements | 
                  Where-Object {($_.tagname -eq 'li') -and ($_.innertext -match 'Current version')} | 
                  select -ExpandProperty innertext
   $AppVersion = $AppVersion.split(':')[-1].trim()

   $URLstub = $download_page.links | 
                  Where-Object {$_.innertext -match 'download installer'} |
                  select -ExpandProperty href

   $url = "$Release$URLstub" -replace 'latest',"$AppVersion"

   return @{ 
        Version    = $AppVersion
        URL32      = $url
        AppVersion = $AppVersion
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.AppVersion)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading ContextConsole $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
