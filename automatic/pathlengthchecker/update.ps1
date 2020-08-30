import-module au

$Release = 'https://github.com/deadlydog/PathLengthChecker/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $stub = $download_page.rawcontent.split('"') | ? {$_ -match 'PathLengthChecker[0-9.]+\.zip$'}

   $version = ($stub -split '/' | Where-Object {$_ -match '^v?[0-9.]+$'}).trim('v')

   return @{ 
            Version    = $version
            URL32      = "https://github.com$Stub"
           }
}


function global:au_SearchReplace {
    @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
      }
    }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading PathLengthChecker $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
