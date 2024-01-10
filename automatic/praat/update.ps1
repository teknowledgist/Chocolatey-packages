import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/praat/praat'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL32 = $Release.Assets | 
               Where-Object {$_.FileName -match 'win(-intel)?32\.zip'} | 
               Select-Object -First 1 -ExpandProperty DownloadURL
   $URL64 = $Release.Assets | 
               Where-Object {$_.FileName -match 'win(-intel)?64\.zip'} | 
               Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
            AppVersion = $Version
            Version    = $version
            URL32      = $URL32
            URL64      = $URL64
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
   Write-host "Downloading Praat $($Latest.AppVersion) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
