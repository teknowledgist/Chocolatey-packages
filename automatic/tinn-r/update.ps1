import-module au

$FilesPage = 'https://sourceforge.net/projects/tinn-r/files'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   $download_page = Invoke-WebRequest -Uri $FilesPage

   $stub = ($download_page.links |
                 Where-Object {$_.href -match 'latest'} | 
                 Select-Object -ExpandProperty title).split(':')[0]

   $Version = $stub.split('/') | ? {$_ -match '^[0-9.]+$'}

   $url = "$FilesPage$stub" -replace ' ','%20'

   return @{ 
            Version    = $Version
            URL32      = $url
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
   Write-host "Downloading Tinn-R $($Latest.Version) installer files"
   Get-RemoteFiles -Purge -nosuffix 
}

update -ChecksumFor none
