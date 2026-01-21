import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'http://code.kliu.org/cmdopen/'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $null = $download_page.rawcontent -split '<\/?li' | 
                  Where-Object {$_ -match '>([0-9.]+)<'} | select -first 1
   $AppVersion = $matches[1]

   $URLstub = $download_page.links | 
                  Where-Object {$_.OuterHTML -match 'download installer'} |
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
