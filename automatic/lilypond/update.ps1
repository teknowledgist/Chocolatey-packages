import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://lilypond.org/download.html'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $url32 = $download_page.Links | 
               Where-Object {$_.href -match '\.zip$'} | 
               Select-Object -first 1 -expand href

   $version = ($url32.split('/') | ? {$_ -match '^v?([0-9.]+)$'}).trim('v')
   return @{
      URL32         = [uri]$url32
      Version       = [version]$version
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version\s*:).*" = "`${1} $($Latest.Version)"
            "(^- URL\s*:).*"     = "`${1} $($Latest.URL32)"
            "(^- SHA256\s*:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading LilyPond $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none

