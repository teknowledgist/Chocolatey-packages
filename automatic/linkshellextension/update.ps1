import-module au

$DownloadURI = 'https://schinagl.priv.at/nt/hardlinkshellext/hardlinkshellext.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $URLs = $download_page.Links | 
               Where-Object {$_.href -match '\.exe$' -and $_.innertext -match 'Link Shell'} | 
               Select-Object -ExpandProperty href -First 2   

   $url32 = $URLs | Where-Object {$_ -match "win32"}
   $url64 = $URLs | Where-Object {$_ -match "x64"}

   $versionstring = $download_page.AllElements | 
                        Where-Object {$_.tagname -eq 'i' -and $_.innertext -match 'version'}
   $version = $versionstring.innertext -replace ".*version ([0-9.]+)",'$1'

   return @{ 
            Version = $version
            URL32   = $url32
            URL64   = $url64
           }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s*:)(.*)"         = "`$1 $($Latest.Version)"
         "(^x86 URL\s*:\s*)('.*')"    = "`$1'$($Latest.URL32)'"
         "(^x86 SHA256\s*:\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
         "(^x64 URL\s*:\s*)('.*')"    = "`$1'$($Latest.URL64)'"
         "(^x64 SHA256\s*:\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Link Shell Extension $($Latest.AppVersion) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
