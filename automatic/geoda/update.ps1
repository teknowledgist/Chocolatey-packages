import-module au

$Release = 'https://geodacenter.github.io/download_windows.html'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release

   $regex = '^.*?/(.*?\.zip).*'
   $urls = $download_page.links | ? {$_.href -match 'geoda-.*\.exe'} | select -ExpandProperty href -First 2
   $url64 = $urls[0]
   $url32 = $urls[1]

   $version = (($urls[0] -split '/')[-1] -split '-')[1]

   return @{ 
            AppVersion = $Version
            Version    = $version
            URL32      = $url32
            URL64      = $url64
           }
}


function global:au_SearchReplace {
    @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.AppVersion)"
         "(^x86 URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^x86 Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
         "(^x64 URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^x64 Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
    }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading GeoDa $($Latest.AppVersion) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
