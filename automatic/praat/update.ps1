import-module au

$Release = 'https://github.com/praat/praat/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urls = $download_page.rawcontent.split(" ") | Where-Object {$_ -match 'win(32|64)\.zip"'}
   $Stub64 = ($urls | Where-Object {$_ -match 'win64'}).trim('"').split('"')[-1]
   $Stub32 = ($urls | Where-Object {$_ -match 'win32'}).trim('"').split('"')[-1]

   $version = ($urls[0] -split '/' | Where-Object {$_ -match '^v[0-9.]+$'}).trim('v')

   return @{ 
            AppVersion = $Version
            Version    = $version
            URL32      = "https://github.com$Stub32"
            URL64      = "https://github.com$Stub64"
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
