import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/moneymanagerex/moneymanagerex'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL32 = $Release.Assets | Where-Object {$_.FileName -match 'win32\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL
   $URL64 = $Release.Assets | Where-Object {$_.FileName -match 'win64\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
            Version    = $version
            URL32      = $URL32
            URL64      = $URL64
           }
}


function global:au_SearchReplace {
    @{
      "legal\VERIFICATION.md" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^x86 URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^x86 Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
         "(^x64 URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^x64 Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
    }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading MoneyManagerEX $($Latest.AppVersion) installer files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
