import-module au

function global:au_GetLatest {
   $Release = 'https://geodacenter.github.io/download_windows.html'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release

   $Links = $download_page.links | 
               Where-Object {$_.href -match 'geoda-.*\.zip'} | 
               Select-Object -First 2
   $url64 = $Links[0].href
   $url32 = $Links[1].href

   $Version = ($links[0].innertext.split() | Where-Object {$_ -match '^v?[0-9.]+$'}).trim('v')

   return @{ 
            Version    = $Version
            URL32      = $url32
            URL64      = $url64
           }
}


function global:au_SearchReplace {
    @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^x86 URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^x86 Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
         "(^x64 URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^x64 Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
    }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading GeoDa $($Latest.Version) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
