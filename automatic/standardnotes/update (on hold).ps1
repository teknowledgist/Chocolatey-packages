import-module au

$Release = 'https://github.com/standardnotes/desktop/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstubs = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match '\.exe"'} | Select-Object -First 1

   $url32 = ($urlstubs) -replace '.*?"([^ ]+\.exe).*','$1'

   $version = ($url32.split('/') | Where-Object {$_ -match '^v[0-9.]+$'}).trim('v')

   return @{ 
      Version = $version
      URL32   = "https://github.com" + $url32
   }
}


function global:au_SearchReplace {
   @{
       "tools\VERIFICATION.txt" = @{
          "(^Version\s+: ).*"  = "`$1 $($Latest.Version)"
          "(^URL\s+: ).*"      = "`$1$($Latest.URL32)"
          "(^Checksum\s+: ).*" = "`$1$($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Standard Notes v$($Latest.Version) installer"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none -nocheckchocoversion
