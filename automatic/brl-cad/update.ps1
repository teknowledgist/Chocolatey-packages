import-module au

$FilesPage = 'https://sourceforge.net/projects/brlcad/files/'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   $download_page = Invoke-WebRequest -Uri $FilesPage

   $stub = ($download_page.links |
                 Where-Object {$_.href -match 'latest'} | 
                 Select-Object -ExpandProperty title).split(':')[0]

   $Version = $stub.split('/') | ? {$_ -match '^[0-9.]+$'}

   $url = "$FilesPage$stub" -replace ' ','%20' -replace '\.exe$','.msi'

   return @{ 
            Version    = $Version
            URL64      = $url
           }
}

function global:au_SearchReplace {
    @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
    }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading BRL-CAD $($Latest.Version) installer"
   Get-RemoteFiles -Purge -nosuffix 
}

update -ChecksumFor none
